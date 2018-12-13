# Metadata about a logbook file that a {User user} has submitted for backup.
# Actual backup data is managed by Active Storage. When a backup is created, the
# logbook file (a SQLite database file) is read and some facts about the logbook
# are stored to help the user determine which backup is which.
#
# Properties
# ----------
#
# |                    |                                                                                                             |
# |:-------------------|:------------------------------------------------------------------------------------------------------------|
# | `total_hours`      | Sum of all flight entry durations in the logbook.                                                           |
# | `hostname`         | The name of the computer that uploaded the logbook (provided by the uploader software).                     |

class Backup < ApplicationRecord
  belongs_to :user, inverse_of: :backups

  validates :logbook,
            presence: true
  validates :hostname,
            length:    {maximum: 128},
            allow_nil: true

  has_one_attached :logbook

  # @return [true, false] If this is the most recent backup for this user.

  def most_recent?
    user.backups.order('created_at DESC').first.id == id
  end

  %i[total_hours last_flight].each do |property|
    define_method(property) do
      return nil unless logbook&.attachment&.metadata.present?

      return logbook.metadata[property.to_s]
    end
  end
end
