# Container module for Action Cable classes.

module ApplicationCable

  # The base Action Cable connection class. Handles authenticating WebSocket
  # connections.
  #
  # Connections are identified by a {User}'s JSON web token (JWT). When making a
  # request to `/cable`, pass the JWT as a query parameter
  # (`/cable?jwt=abc123`).

  class Connection < ActionCable::Connection::Base
    # @return [String] The user's JSON web token.
    attr_reader :jwt

    identified_by :current_user

    # @private
    def connect
      @jwt = token_decoder.call(request.params[:jwt]) or reject_unauthorized_connection
      self.current_user = find_verified_user
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      reject_unauthorized_connection
    end

    private

    def find_verified_user
      User.find_by_email!(jwt['e'])
    end

    def token_decoder
      @token_decoder ||= Warden::JWTAuth::TokenDecoder.new
    end
  end
end
