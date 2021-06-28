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
synchronizer_port       = node["imv"]["client"]["synchronizer_port"]
synchronizer_port_ssl   = node["imv"]["client"]["synchronizer_port_ssl"]
synchronizer_target     = node["imv"]["client"]["synchronizer_target"]
synchronizer_target_ssl = node["imv"]["client"]["synchronizer_target_ssl"]
https                   = node["imv"]["client"]["https"]
react_app_auth0_domain  = node["imv"]["client"]["react_app_auth0_domain"]
react_app_auth0_client_id = node["imv"]["client"]["react_app_auth0_client_id"]
ssl_ca_file             = node["imv"]["ssl_ca_file"]
ssl_cert_file           = node["imv"]["ssl_cert_file"]
ssl_cert_key_file       = node["imv"]["ssl_cert_key_file"]
home                    = node["imv"]["home"]
user                    = node["imv"]["user"]
owner                   = node["imv"]["owner"]
group                   = node["imv"]["group"]



fail "Auth0 domain is undefined" unless react_app_auth0_domain && !react_app_auth0_domain.empty?
fail "Auth0 client_id is undefined" unless react_app_auth0_client_id && !react_app_auth0_client_id.empty?

#####################
# installation process
#####################

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
    "PORT" => port,
    "PORT_SSL" => port_ssl,
    "API_TARGET" => api_target,
    "API_TARGET_SSL" => api_target_ssl,
    "SYNCHRONIZER_PORT" => synchronizer_port,
    "SYNCHRONIZER_PORT_SSL" => synchronizer_port_ssl,
    "SYNCHRONIZER_TARGET" => synchronizer_target,
    "SYNCHRONIZER_TARGET_SSL" => synchronizer_target_ssl,
    "REACT_APP_AUTH0_DOMAIN" => react_app_auth0_domain,
    "REACT_APP_AUTH0_CLIENT_ID" => react_app_auth0_client_id,
    "HTTPS" => https,
    "SSL_CA_FILE" => ssl_ca_file,
    "SSL_CERT_FILE" => ssl_cert_file,
    "SSL_CERT_KEY_FILE" => ssl_cert_key_file
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
