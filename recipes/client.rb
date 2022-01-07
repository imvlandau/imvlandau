#
# Cookbook:: imvlandau
# Recipe:: client
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

npm_command             = node["imv"]["client"]["npm_command"]
port                    = node["imv"]["client"]["port"]
port_ssl                = node["imv"]["client"]["port_ssl"]
api_target              = node["imv"]["client"]["api_target"]
api_target_ssl          = node["imv"]["client"]["api_target_ssl"]
https                   = node["imv"]["client"]["https"]
react_app_auth0_domain  = node["imv"]["client"]["react_app_auth0_domain"]
react_app_auth0_client_id = node["imv"]["client"]["react_app_auth0_client_id"]
react_app_auth0_audience = node["imv"]["client"]["react_app_auth0_audience"]
react_app_base_url      = node["imv"]["client"]["react_app_base_url"]
ssl_ca_file             = node["imv"]["ssl_ca_file"]
ssl_crt_file            = node["imv"]["ssl_crt_file"]
ssl_key_file            = node["imv"]["ssl_key_file"]
home                    = node["imv"]["home"]
user                    = node["imv"]["user"]
owner                   = node["imv"]["owner"]
group                   = node["imv"]["group"]



fail "Auth0 domain is undefined" unless react_app_auth0_domain && !react_app_auth0_domain.empty?
fail "Auth0 client_id is undefined" unless react_app_auth0_client_id && !react_app_auth0_client_id.empty?
fail "Auth0 audience is undefined" unless react_app_auth0_audience && !react_app_auth0_audience.empty?
fail "Base URL is undefined" unless react_app_base_url && !react_app_base_url.empty?

#####################
# installation process
#####################

apt_update

include_recipe "imvlandau::default"
include_recipe "imvlandau::nodejs"

apt_package [
      "build-essential"
    ] do
    action :install
end

replace_or_add "add alias for /var/www/imvlandau-client" do
  path "#{home}/.bashrc"
  pattern "alias imv=\"cd /var/www/imvlandau-client\""
  line "alias imv=\"cd /var/www/imvlandau-client\""
end

bash "install pm2 and rimraf" do
  cwd "/tmp"
  code <<-EOH
    sudo npm install -g pm2@3.5.1 rimraf
  EOH
  user "root"
  group "root"
  action :run
end


#####################
# setup process
#####################

include_recipe "imvlandau::bashrc"
include_recipe "imvlandau::ssl"

#####################
# deployment process
#####################

include_recipe "imvlandau::git"

directory "/var/www/imvlandau-client" do
  owner owner
  group group
  mode "755"
  action :create
end

git "imvlandau-client" do
  repository "git@github.com:imvlandau/imvlandau-client.git"
  revision "master"
  destination "/var/www/imvlandau-client"
  ssh_wrapper "/usr/local/bin/git_wrapper.sh"
  user user
  group group
  action :sync
end

template "/var/www/imvlandau-client/.env.local" do
  source ".env.local.erb"
  variables(config: {
    "NODE_ENV" => node.chef_environment,
    "PORT" => port,
    "PORT_SSL" => port_ssl,
    "API_TARGET" => api_target,
    "API_TARGET_SSL" => api_target_ssl,
    "SSL_CA_FILE" => ssl_ca_file,
    "SSL_CRT_FILE" => ssl_crt_file,
    "SSL_KEY_FILE" => ssl_key_file,
    "HTTPS" => https,
    "REACT_APP_AUTH0_DOMAIN" => react_app_auth0_domain,
    "REACT_APP_AUTH0_CLIENT_ID" => react_app_auth0_client_id,
    "REACT_APP_AUTH0_AUDIENCE" => react_app_auth0_audience,
    "REACT_APP_BASE_URL" => react_app_base_url
  })
  owner owner
  group group
  mode "644"
  action :create
end

execute "npm-install" do
  cwd "/var/www/imvlandau-client"
  user user
  group group
  environment ({"HOME" => home, "USER" => user})
  command "npm install"
  action :run
end


#####################
# execution process
#####################

execute "npm-run" do
  cwd "/var/www/imvlandau-client"
  command npm_command
  user user
  group group
  environment ({
    "HOME" => home,
    "USER" => user
  })
  action :run
end
