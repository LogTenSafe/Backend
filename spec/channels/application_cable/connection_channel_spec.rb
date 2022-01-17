require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create :user }
  let(:jwt) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  it "subscribes for a valid JWT" do
    connect "/cable?jwt=#{CGI.escape jwt}"
    expect(connection.current_user).to eql(user)
  end

  it "rejects an invalid JWT" do
    expect { connect "/cable?jwt=abc123" }.to have_rejected_connection
  end
end
