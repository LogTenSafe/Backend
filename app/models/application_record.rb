# @abstract
#
# Base class for all Active Record models in this project.

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
