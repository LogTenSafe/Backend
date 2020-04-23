Rails.application.routes.draw do
  unless Rails.env.development?
    mount ActionCable.server => '/cable'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
    mount Sidekiq::Web => '/sidekiq'
  end

  constraints(->(req) { req.format != '*/*' && !req.format.html? }) do
    resources :backups, only: %i[index show create destroy]
    devise_for :users
    devise_scope :user do
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      post 'signup' => 'registrations#create'
      delete 'signup' => 'registrations#destroy'
      patch 'signup' => 'registrations#update'
      put 'signup' => 'registrations#update'
    end
  end

  root to: redirect(Rails.application.config.urls.frontend)
end
