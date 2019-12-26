set :stage, :production

role :app, %w[deploy@www.logtensafe.com]
role :web, %w[deploy@www.logtensafe.com]
role :db,  %w[deploy@www.logtensafe.com]
