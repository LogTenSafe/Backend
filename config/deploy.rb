# config valid only for current version of Capistrano
lock '~> 3.10.1'

set :application, 'logtensafe'
set :repo_url, 'git://github.com/LogTenSafe/website.git'

set :deploy_to, '/var/www/www.logtensafe.com'
set :rvm_ruby_version, "2.5.1@#{fetch :application}"

append :linked_files, 'config/secrets.yml',
       'config/environments/production/secrets.yml',
       'config/sidekiq.yml', 'config/sidekiq_web_credentials.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'public/system'
