set :deploy_to, "/rails/#{application}/production"
set :rails_env, "production"

namespace :deploy do
  task :db_migrate do
    run "export PATH=$PATH:/var/lib/gems/1.8/bin/ && cd #{release_path} && bundle exec rake RAILS_ENV=production db:create" unless File.exists?(current_path)
    run "export PATH=$PATH:/var/lib/gems/1.8/bin/ && cd #{release_path} && bundle exec rake RAILS_ENV=production db:migrate"
  end
  task :symlink_passenger do
    run "#{try_sudo} rm -rf /var/www/#{application}_production" if File.exists?("/var/www/#{application}_production")
    run "#{try_sudo} ln -s #{release_path}/public /var/www/#{application}_production"
  end
end