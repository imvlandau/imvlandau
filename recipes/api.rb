#
# Cookbook:: imvlandau
# Recipe:: api
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

server_port       = node["imv"]["api"]["port"]
server_port_ssl   = node["imv"]["api"]["port_ssl"]
server_name       = node["imv"]["api"]["server_name"]
server_alias      = node["imv"]["api"]["server_alias"]
server_admin      = node["imv"]["api"]["server_admin"]
document_root     = node["imv"]["api"]["document_root"]
path_error_log    = node["imv"]["api"]["path_error_log"]
path_access_log   = node["imv"]["api"]["path_access_log"]
site_conf         = node["imv"]["api"]["site_conf"]
site_conf_ssl     = node["imv"]["api"]["site_conf_ssl"]
timezone          = node["imv"]["api"]["timezone"]
database_hostname = node["imv"]["database"]["system"]["short_hostname"]
database_name     = node["imv"]["database"]["name"]
database_user     = node["imv"]["database"]["user"]
database_password = node["imv"]["database"]["user_password"]
database_port     = node["imv"]["database"]["port"]
home              = node["imv"]["home"]
user              = node["imv"]["user"]
owner             = node["imv"]["owner"]
group             = node["imv"]["group"]
ssl_crt_file      = node["imv"]["ssl_crt_file"]
ssl_key_file      = node["imv"]["ssl_key_file"]



fail "Database hostname is undefined" unless database_hostname && !database_hostname.empty?
database_url="pgsql://#{database_user}:#{database_password}@#{database_hostname}:#{database_port}/#{database_name}"


#####################
# installation process
#####################

include_recipe "imvlandau::default"
include_recipe "imvlandau::apache2"
include_recipe "imvlandau::nodejs"

bash "install composer" do
  cwd "/tmp"
  code "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"
  user "root"
  group "root"
  action :run
end


#####################
# setup process
#####################

include_recipe "imvlandau::bashrc"

replace_or_add "add alias for /var/www/imvlandau-api" do
  path "#{home}/.bashrc"
  pattern "alias imv=\"cd /var/www/imvlandau-api\""
  line "alias imv=\"cd /var/www/imvlandau-api\""
end

# create virtual host
template "/etc/apache2/sites-available/#{site_conf}.conf" do
  source "site.conf.erb"
  variables(
    :SERVER_PORT => server_port,
    :SERVER_NAME => server_name,
    :SERVER_ALIAS => server_alias,
    :SERVER_ADMIN => server_admin,
    :DOCUMENT_ROOT => document_root,
    :HOME => home,
    :PATH_ERROR_LOG => path_error_log,
    :PATH_ACCESS_LOG => path_access_log
  )
  owner owner
  group group
  mode "644"
  action :create
end

include_recipe "imvlandau::ssl"

# create virtual host for ssl connection
template "/etc/apache2/sites-available/#{site_conf_ssl}.conf" do
  source "site-ssl.conf.erb"
  variables(
    :SERVER_PORT_SSL => server_port_ssl,
    :SERVER_NAME => server_name,
    :SERVER_ALIAS => server_alias,
    :SERVER_ADMIN => server_admin,
    :DOCUMENT_ROOT => document_root,
    :HOME => home,
    :PATH_ERROR_LOG => path_error_log,
    :PATH_ACCESS_LOG => path_access_log,
    :SSL_CRT_FILE => ssl_crt_file,
    :SSL_KEY_FILE => ssl_key_file
  )
  owner owner
  group group
  mode "644"
  action :create
end

cookbook_file "/etc/php/7.4/mods-available/opcache.ini" do
  source "opcache#{node.chef_environment == "development" ? "_dev" : ""}.ini"
  owner "root"
  group "root"
  mode "644"
  action :create
end

execute "enable opcache" do
  user "root"
  group "root"
  command "phpenmod opcache"
  notifies :restart, "service[apache2]"
  action :run
end

template "/etc/php/7.4/mods-available/imvlandau.ini" do
  source "imvlandau.ini.erb"
  variables(
    :TIMEZONE => timezone
  )
  owner owner
  group group
  mode "600"
  action :create
end

execute "enable imvlandau.ini" do
  user "root"
  group "root"
  command "phpenmod imvlandau"
  notifies :restart, "service[apache2]"
  action :run
end


#####################
# deployment process
#####################

include_recipe "imvlandau::git"

directory "/var/www/imvlandau-api" do
  owner owner
  group group
  mode "755"
  action :create
end

git "imvlandau-api" do
  repository "git@github.com:imvlandau/imvlandau-api.git"
  revision "master"
  destination "/var/www/imvlandau-api"
  ssh_wrapper "/usr/local/bin/git_wrapper.sh"
  user user
  group group
  action :sync
end

execute "run composer install" do
  cwd "/var/www/imvlandau-api"
  user user
  group group
  command "composer install --no-interaction"
  action :run
end

append_if_no_line "add database_url environment variable" do
  path "/var/www/imvlandau-api/.env.local"
  line "DATABASE_URL=#{database_url}"
  action :edit
end

execute "change owner of .env.local" do
  cwd "/var/www/imvlandau-api"
  command "chown #{owner}:#{group} .env.local"
  not_if "stat -c %U /var/www/imvlandau-api/.env.local | grep -q #{owner}"
end

directory "/var/www/imvlandau-api/var/userData" do
  owner user
  group group
  mode "755"
  action :create
end

execute "add phpinfo file" do
  user user
  group group
  command "echo \"<?php phpinfo(); ?>\" > /var/www/imvlandau-api/public/info.php"
  only_if { node.chef_environment == "development" }
  action :run
end

file "remove phpinfo file" do
  path "/var/www/imvlandau-api/public/info.php"
  only_if { node.chef_environment != "development" && ::File.exist?("/var/www/imvlandau-api/public/info.php") }
  action :delete
end


#####################
# execution process
#####################

apache2_site "000-default" do
  action :disable
end

apache2_site site_conf do
  notifies :restart, "service[apache2]"
  action :enable
end

apache2_site site_conf_ssl do
  notifies :restart, "service[apache2]"
  action :enable
end
