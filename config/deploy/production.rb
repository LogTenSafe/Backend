set :stage, :production

role :app, %w{www-data@www.logtensafe.com}
role :web, %w{www-data@www.logtensafe.com}
role :db,  %w{www-data@www.logtensafe.com}
