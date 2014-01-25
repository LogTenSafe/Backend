# Metadata about a logbook file that a {User user} has submitted for backup.
# Actual backup data is managed by Paperclip. When a backup is created, the
# logbook file (a SQLite database file) is read and some facts about the logbook
# are stored to help the user determine which backup is which.
#
# Properties
# ----------
#
# |                    |                                                                                                             |
# |:-------------------|:------------------------------------------------------------------------------------------------------------|
# | `logbook_*`        | Paperclip fields storing metadata about the logbook.                                                        |
# | `last_flight_date` | The date of the most recent flight entry.                                                                   |
# | `last_flight`      | YAML-encoded hash of data about the most recent flight (currently `origin`, `destination`, and `duration`). |
# | `total_hours`      | Sum of all flight entry durations in the logbook.                                                           |
# | `hostname`         | The name of the computer that uploaded the logbook (provided by the uploader software).                     |

class Backup < ActiveRecord::Base
  belongs_to :user, inverse_of: :backups

  validates :user,
            presence: true
  validates :logbook,
            presence: true
  validates :logbook_file_size,
            numericality: { less_than: 20.megabytes }
  validates :logbook_fingerprint,
            uniqueness: {scope: :user_id}
  validates :total_hours,
            numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
  validates :hostname,
            length:    { maximum: 128 },
            allow_nil: true

  do_not_validate_attachment_file_type :logbook

  before_validation :set_logbook_metadata, on: :create

  attr_readonly :logbook
  has_attached_file :logbook
  serialize :last_flight, Hash

  # @return [true, false] If this is the most recent backup for this user.

  def most_recent?
    user.backups.order('created_at DESC').first.id == id
  end

  private

  def set_logbook_metadata
    return unless logbook_file

    db = SQLite3::Database.new(logbook_file)

    columns, last_flight = db.execute2('SELECT * FROM ZFLIGHT ORDER BY ZFLIGHT_FLIGHTDATE DESC LIMIT 1').first(2)
    last_flight          = Hash[*columns.zip(last_flight).flatten]

    self.last_flight_date = Time.utc(2001).advance(seconds: last_flight['ZFLIGHT_FLIGHTDATE']).utc.to_date

    # unfortunately, to calculate total hours we can't simply do a SUM() query.
    # total time is not the sum of the # of minutes of all flights; instead, each
    # time is rounded to the 1/10th of an hour, and those values are summed.
    # sqlite rounds, e.g. 0.85 down to 0.8, not up to 0.9, due to the way it
    # stores floats internally. this is different than the way the LogTen
    # application does fractional math, resulting in compounding discrepancies
    # in time calculations. to solve this, we instead take the numbers into
    # ruby-land, and sum them there, where the result is equal to the one logten
    # gives.
    times                 = db.execute('SELECT ZFLIGHT_TOTALTIME FROM ZFLIGHT').flatten
    self.total_hours      = times.map { |t| (t/60.0).round(1) }.sum

    self.last_flight = {
      'origin'      => db.get_first_value('SELECT ZPLACE_FAAID FROM ZPLACE WHERE Z_PK = ?', last_flight['ZFLIGHT_FROMPLACE']),
      'destination' => db.get_first_value('SELECT ZPLACE_FAAID FROM ZPLACE WHERE Z_PK = ?', last_flight['ZFLIGHT_TOPLACE']),
      'duration'    => (last_flight['ZFLIGHT_TOTALTIME']/60.0).round(1)
    }
  end

  def logbook_file
    if logbook.file?
      if logbook.pending_file
        logbook.pending_file.path
      elsif File.exist?(logbook.path)
        logbook.path
      else
        nil
      end
    else
      nil
    end
  end
end
