Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :account, controller: 'account', only: [:edit, :update, :destroy]
  resources :users, only: [:new, :create]
  resources :backups, only: [:index, :show, :create, :destroy]

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  root to: 'backups#index'

  if Rails.env.production?
    require 'sidekiq/web'
    creds = YAML.load_file('config/sidekiq_web_credentials.yml')
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks: (https://codahale.com/a-lesson-in-timing-attacks/)
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use `secure_compare` to stop length information leaking
      ActiveSupport::SecurityUtils.secure_compare(username, creds['username']) &
          ActiveSupport::SecurityUtils.secure_compare(password, creds['password'])
    end
    mount Sidekiq::Web => '/sidekiq'
  end
end
