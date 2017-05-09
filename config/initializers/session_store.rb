# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Rails.application.config.session_store :redis_store, servers: ['redis://localhost:6379/0/logtensafe_session']
else
  Rails.application.config.session_store :cookie_store, key: '_logtensafe_session'
end
