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
ssl_cert_file     = node["imv"]["ssl_cert_file"]
ssl_cert_key_file = node["imv"]["ssl_cert_key_file"]
aws_access_key_id = node["imv"]["aws_access_key_id"]
aws_secret_access_key = node["imv"]["aws_secret_access_key"]
aws_price_list_service_enpoint = node["imv"]["aws_price_list_service_enpoint"]
aws_ec2_service_enpoint        = node["imv"]["aws_ec2_service_enpoint"]


fail "Database hostname is undefined" unless database_hostname && !database_hostname.empty?
fail "AWS_ACCESS_KEY_ID is undefined" unless aws_access_key_id && !aws_access_key_id.empty?
fail "AWS_SECRET_ACCESS_KEY is undefined" unless aws_secret_access_key && !aws_secret_access_key.empty?

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

# install ansible
apt_package [
  "software-properties-common",
  "python-pip"
  ] do
    action :install
end

apt_repository "ansible" do
    uri "ppa:ansible/ansible"
    components ["main"]
    distribution "bionic"
    action :add
end

apt_package "ansible" do
    action :install
end

execute "install passlib and boto with pip" do
  user "root"
  group "root"
  command "pip install passlib boto"
  action :run
end

# install supervisord for rabbitmq
apt_package [
  "supervisor",
  "librabbitmq-dev"
  ] do
    action :install
end

bash "install librabbitmq php extension" do
  code <<-EOH
    pecl channel-update pecl.php.net
    printf "\n" | pecl install amqp
  EOH
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
    :SSL_CERT_FILE => ssl_cert_file,
    :SSL_CERT_KEY_FILE => ssl_cert_key_file
  )
  owner owner
  group group
  mode "644"
  action :create
end

cookbook_file "/etc/php/7.2/mods-available/opcache.ini" do
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

template "/etc/php/7.2/mods-available/imvlandau.ini" do
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

cookbook_file "/etc/supervisor/conf.d/imv-messenger-worker.conf" do
  source "imv-messenger-worker.conf"
  owner "root"
  group "root"
  mode "600"
  action :create
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

# create AWS credentials folder for credentials shared between SDKs
directory "#{home}/.aws" do
  owner owner
  group group
  mode "700"
  action :create
end

# create AWS credentials file for credentials shared between SDKs
template "#{home}/.aws/credentials" do
  source "credentials.erb"
  variables(
    :AWS_ACCESS_KEY_ID => aws_access_key_id,
    :AWS_SECRET_ACCESS_KEY => aws_secret_access_key
  )
  owner owner
  group group
  action :create
end

append_if_no_line "add database_url environment variable" do
  path "/var/www/imvlandau-api/.env.local"
  line "DATABASE_URL=#{database_url}"
  action :edit
end

append_if_no_line "add AWS price list service endpoint environment variable" do
  path "/var/www/imvlandau-api/.env.local"
  line "AWS_PRICE_LIST_SERVICE_ENDPOINT=#{aws_price_list_service_enpoint}"
  action :edit
end

append_if_no_line "add AWS EC2 service endpoint environment variable" do
  path "/var/www/imvlandau-api/.env.local"
  line "AWS_EC2_SERVICE_ENDPOINT=#{aws_ec2_service_enpoint}"
  action :edit
end

append_if_no_line "add AWS access key id to .env.local" do
  path "/var/www/imvlandau-api/.env.local"
  line "AWS_KEY=#{aws_access_key_id}"
  action :edit
end

append_if_no_line "add AWS secret access key to .env.local" do
  path "/var/www/imvlandau-api/.env.local"
  line "AWS_SECRET=#{aws_secret_access_key}"
  action :edit
end

execute "change owner of .env.local" do
  cwd "/var/www/imvlandau-api"
  command "chown #{owner}:#{group} .env.local"
  not_if "stat -c %U /var/www/imvlandau-api/.env.local | grep -q #{owner}"
end

aws_s3_file "#{home}/.ssh/imv-predefined-ec2-instance.pem" do
  bucket "imvlandau"
  remote_path "imv-predefined-ec2-instance.pem"
  aws_access_key aws_access_key_id
  aws_secret_access_key aws_secret_access_key
  region "us-east-2"
  owner owner
  group group
  mode "600"
  action :create
end

directory "/var/www/imvlandau-api/var/userData" do
  owner user
  group group
  mode "755"
  action :create
end

execute "run create-react-app" do
  cwd "/var/www/imvlandau-api/var/userData"
  user user
  group group
  environment ({
    "HOME" => home,
    "USER" => user
  })
  command "npx create-react-app create-react-app"
  not_if { ::Dir.exists?("/var/www/imvlandau-api/var/userData/create-react-app")}
  action :run
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

bash "initialize and start supervisor" do
  code <<-EOH
    sudo supervisorctl reread
    sudo supervisorctl update
    sudo supervisorctl start imv-messenger-consume:*
  EOH
  user "root"
  group "root"
  action :run
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
