lock '3.2.1'

set :application, 'LogTenSafe'
set :repo_url, 'git://github.com/LogTenSafe/website.git'

set :deploy_to, '/var/www/www.logtensafe.com'
set :rvm_ruby_version, "2.1.2@#{fetch :application}"

set :linked_files, %w{config/environments/production/secrets.yml config/secrets.yml config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp', 'restart.txt')
    end
  end

  after :finishing, :restart
  after :finishing, :cleanup
end
