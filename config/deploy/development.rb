set :deploy_to, "/rails/#{application}/development"
set :rails_env, "development"

namespace :deploy do
  task :db_migrate do
    run "export PATH=$PATH:/var/lib/gems/1.8/bin/ && cd #{release_path} && bundle exec rake RAILS_ENV=development db:create" unless File.exists?(current_path)
    run "export PATH=$PATH:/var/lib/gems/1.8/bin/ && cd #{release_path} && bundle exec rake RAILS_ENV=development db:migrate"
  end
  task :symlink_passenger do
    run "#{try_sudo} rm -rf /var/www/#{application}_development" if File.exists?("/var/www/#{application}_development")
    run "#{try_sudo} ln -s #{release_path}/public /var/www/#{application}_development"
  end
end