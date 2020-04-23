# @abstract
#
# Abstract superclass for LogTenSafe mailers.

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@logtensafe.com'
  layout 'mailer'
end
