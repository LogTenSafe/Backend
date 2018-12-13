# @abstract
#
# Base class for all mailers in this project.

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@logtensafe.com'
  layout 'mailer'
end
