# The name of your app
set :application, "simple_cms"

# The directory on the EC2 node that will be deployed to
set :deploy_to, "/var/www/#{application}"

set :keep_releases, 3

# deploy with git
set :scm, :git
set :repository,  "git@github.com:SilverNightFall/sample_app.git"
set :git_shallow_clone, 1
set :branch, "master"
set :use_sudo, true

# gets ssh info
set :user, "ubuntu"
ssh_options[:keys] = ["/Users/Victoria/Documents/ServerKeys/key.pem"]
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

# The address of the remote host on EC2 (the Public DNS address)
set :location, "server.silvernightfall.com"

# setup some Capistrano roles
role :app, location
role :web, location
role :db,  location, :primary => true

after 'deploy:update_code', 'deploy:symlink_db'

namespace :deploy do

# If you are using Passenger mod_rails uncomment this:

#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

desc "Restart Application"
task :restart, :roles => :app do
  run "touch #{deploy_to}/#{shared_dir}/tmp/restart.txt"
end

desc "Symlinks the database.yml"
task :symlink_db, :roles => :app do
  run "ln -nfs #{deploy_to}/shared/config/database.yml
  #{release_path}/config/database.yml"
end


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


after "deploy:restart", "deploy:precompile"

namespace :deploy do

  desc "Compile assets"
  task :precompile, :roles => :app do
    run "cd #{release_path} && rake RAILS_ENV=#{rails_env} assets:precompile"
  end

end







end