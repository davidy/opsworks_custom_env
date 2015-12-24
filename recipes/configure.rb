# Custom Environments from Stack JSON
if node[:opsworks][:instance][:layers].include?('rails-app')

  include_recipe "opsworks_custom_env::restart_command"
  include_recipe "opsworks_custom_env::write_config"

end

# Precompile Assets
Chef::Log.info("Running deploy/before_migrate.rb...")
 
Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")
 
link "#{release_path}/public/assets" do
  to "#{new_resource.deploy_to}/shared/assets"
end
 
rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
 
execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
