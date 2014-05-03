set :stage, :production

set :rvm_type, :system
set :rvm_ruby_version, '2.1.1@logtensafe'

role :app, %w{www-data@www.logtensafe.com}
role :web, %w{www-data@www.logtensafe.com}
role :db,  %w{www-data@www.logtensafe.com}
