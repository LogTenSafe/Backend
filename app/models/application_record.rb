# @abstract
#
# Abstract superclass for LogTenSafe models.

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
