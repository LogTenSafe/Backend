# @private
#
# Allows changes to a blob's metadata to result in Action Cable broadcasts for
# that blob's associated {Backup Backup(s)}.

module AddActionCableTo
  module Attachment
    extend ActiveSupport::Concern

    included do
      after_commit do
        if record.kind_of?(Backup)
          BackupsChannel.broadcast_to record.user,
                                      BackupsChannel::Coder.encode(record)
        end
      end
    end
  end

  module Blob
    extend ActiveSupport::Concern

    included do
      after_commit do
        attachments.includes(:record).find_each do |attachment|
          if attachment.record.kind_of?(Backup)
            BackupsChannel.broadcast_to attachment.record.user,
                                        BackupsChannel::Coder.encode(attachment.record)
          end
        end
      end
    end
  end
end
