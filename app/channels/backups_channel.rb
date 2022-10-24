# frozen_string_literal: true

# Channel that streams all changes to a {User}'s list of {Backup Backups}. New,
# changed, or deleted backups are streamed using the same JSON representation as
# the API uses.

class BackupsChannel < ApplicationCable::Channel

  # @private
  def subscribed
    stream_for current_user, coder: nil
  end

  # Encodes a {Backup} for transmission.

  module Coder
    extend self

    # @private
    def encode(backup)
      ApplicationController.render(partial: "backups/backup", locals: {backup:, include_pagination: true})
    end
  end
end
