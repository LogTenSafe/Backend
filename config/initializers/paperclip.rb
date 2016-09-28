require File.join(File.dirname(__FILE__), 'recursively')

# Update Paperclip it to include global storage configuration options.

Paperclip::Attachment.default_options.update LogTenSafe::Configuration.paperclip.symbolize_keys.recursively!(&:symbolize_keys!)
Paperclip::Attachment.default_options[:s3_credentials] =
  (Paperclip::Attachment.default_options[:s3_credentials] || {}).symbolize_keys.merge LogTenSafe::Configuration.secrets.s3.symbolize_keys

class Paperclip::Attachment
  # Returns the pending file, if one hasn't been assigned yet

  def pending_file
    @queued_for_write[:original]
  end
end
