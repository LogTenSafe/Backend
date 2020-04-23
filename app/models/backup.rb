# An uploaded and backed-up LogTen Pro logbook. Logbooks are SQLite files,
# stored using Active Storage. {LogbookAnalyzer} parses the logbook and
# populates the blob's metadata with information about the logbook.
#
# ## Associations
#
# |        |                                      |
# |:-------|:-------------------------------------|
# | `user` | The {User} who uploaded this backup. |
#
# ## Attachments
#
# |           |                                  |
# |:----------|:---------------------------------|
# | `logbook` | The uploaded LogTen Pro logbook. |
#
# ## Properties
#
# |            |                                                              |
# |:-----------|:-------------------------------------------------------------|
# | `hostname` | The name of the computer the user uploaded the logbook from. |

class Backup < ApplicationRecord
  belongs_to :user

  has_one_attached :logbook

  validates :logbook,
            attached:     true,
            content_type: %w[application/x-sqlite3 application/vnd.sqlite3 application/sql]

  after_commit { BackupsChannel.broadcast_to user, BackupsChannel::Coder.encode(self) }

  scope :analyzed, -> do
    joins(logbook_attachment: :blob).
        where(%(metadata::text LIKE '%\\\\"analyzed\\\\":true%'))
  end
  #TODO do better than this :/

  # @return [true, false] If this is the most recent backup for this user.

  def most_recent?
    user.backups.order(created_at: :desc).first.id == id
  end

  %i[total_hours last_flight].each do |property|
    define_method(property) do
      return nil unless logbook&.attachment&.metadata.present?

      return logbook.metadata[property.to_s]
    end
  end
end
