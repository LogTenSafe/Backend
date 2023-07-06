# frozen_string_literal: true

require "jwt_blacklist"

# A user of this website. Users are identified by their email address. User
# authentication is handled by Devise, mediated by JSON web tokens.
#
# ## Associations
#
# |           |                                             |
# |:----------|:--------------------------------------------|
# | `backups` | The {Backup Backups} uploaded by this user. |
#
# ## Properties
#
# |         |                           |
# |:--------|:--------------------------|
# | `email` | The user's email address. |

class User < ApplicationRecord
  #noinspection RubyConstantNamingConvention
  Devise::Models::JWTAuthenticatable = Devise::Models::JwtAuthenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JWTBlacklist

  has_many :backups, dependent: :destroy

  # @private
  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end

  # @private
  def jwt_payload = {e: email}
end
