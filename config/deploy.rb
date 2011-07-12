require File.expand_path('../deploy/capistrano_database', __FILE__)

set :application, "marktplaats_scraper"
set :repository,  "https://jeroeningen@github.com/jeroeningen/Marktplaats-scraper.git"

set :stages, %w{development production}
set :default_stage, "development"
require 'capistrano/ext/multistage'

set :scm, :git

role :web, "localhost", "192.168.178.41"
role :app, "localhost", "192.168.178.41"
role :db, "localhost", "192.168.178.41", :primary => true
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :database_config_created do
    abort "Please first run 'cap <stage> deploy:setup'" unless File.exists?("#{shared_path}/config/database.yml")
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(release_path,'tmp','restart.txt')}"
  end
  
  task :bundle_install do
    run " cp -R #{previous_release}/vendor/bundle #{release_path}/vendor; true" if File.exists?("#{previous_release}/vendor/bundle")
    run "export PATH=$PATH:/var/lib/gems/1.8/bin/ && cd #{release_path} && bundle install --deployment"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

before "deploy:update_code", "deploy:database_config_created"
after 'deploy:update_code', "deploy:bundle_install", 'deploy:symlink_shared', "deploy:db_migrate", "deploy:symlink_passenger", "deploy:restart"