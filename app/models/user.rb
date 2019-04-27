require 'securerandom'
require 'digest/sha2'

# A user of this website, who uploads logbook {Backup backups}. Users' passwords
# are hashed with a salt and pepper, which is automatically generated. When a
# User is deleted, all his/her backups are instantiated and destroyed so that
# Active Storage can remove the corresponding files as well.
#
# To change the user's password, set the `password` attribute. It will
# automatically be encoded into the `crypted_password` field when the User is
# saved.
#
# Properties
# ----------
#
# |                    |                                                                        |
# |:-------------------|:-----------------------------------------------------------------------|
# | `login`            | The user's login name.                                                 |
# | `crypted_password` | The user's password, sent through a one-way hash, salted and peppered. |
# | `pepper`           | A hash salt unique to this User.                                       |

class User < ApplicationRecord
  has_many :backups, inverse_of: :user, dependent: :destroy

  # Virtual attribute used for changing passwords.
  # @return [String]
  attr_accessor :password, :password_confirmation

  validates :login, :crypted_password, :pepper,
            presence: true,
            length:   {within: 2..128}
  validates :login,
            uniqueness: true
  validates :password,
            confirmation: true,
            length:       {minimum: 4},
            exclusion:    {in: %w[password 1234 12345 123456 letmein]},
            allow_nil:    {on: :update}

  before_validation :set_pepper
  before_validation :encrypt_password, if: :password

  # Attempts to authenticate a user given a password.
  #
  # @param [String] password A proposed password.
  # @return [true, false] Whether the password is correct.

  def authentic?(password)
    digest.update(password).hexdigest == crypted_password
  end

  # Finds a User by login and returns the user if authenticated.
  #
  # @param [String] login A user's login.
  # @param [String] password A user's password.
  # @return [User, nil] The user with that login if the password is correct, or
  #   `nil` for an unknown login or invalid password.

  def self.authenticate(login, password)
    user = User.find_by_login(login)
    (user&.authentic?(password)) ? user : nil
  end

  # @private
  def self.digest
    Digest::SHA2.new.update(Rails.application.credentials.authentication_salt)
  end

  private

  def set_pepper
    self.pepper ||= SecureRandom.base64(90)
  end

  def encrypt_password
    self.crypted_password = digest.update(password).hexdigest
  end

  def digest
    self.class.digest.update(pepper)
  end
end
