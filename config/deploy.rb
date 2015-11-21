lock '3.4.0'

set :application, 'logtensafe'
set :repo_url, 'git://github.com/LogTenSafe/website.git'

set :deploy_to, '/var/www/www.logtensafe.com'
set :rvm_ruby_version, "2.2.3@#{fetch :application}"

set :linked_files, %w{config/environments/production/secrets.yml config/secrets.yml config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  after :finishing, :restart
  after :finishing, :cleanup
end
