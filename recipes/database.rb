#
# Cookbook:: imvlandau
# Recipe:: database
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.
#
#
### check PostgreSQL version with
# dpkg --list | grep -i postgres
# sudo -u postgres psql postgres -c "SELECT version()" | grep PostgreSQL
# psql --version
# postgres -V
#
#
### check for invalid configuration or errors
# 1) sudo service postgresql start
# 2) execute pg_lsclusters to get the path of the log file
# 3) something is wrong, then postgresql will generate a log, that can be
#    accessed on /var/log/postgresql/postgresql-<version>-main.log


Chef::Recipe.send(:include, PostgresqlCookbook::Helpers)

###########
# variables
###########

database_name          = node["imv"]["database"]["name"]
database_user          = node["imv"]["database"]["user"]
database_user_password = node["imv"]["database"]["user_password"]
database_root          = node["imv"]["database"]["root"]
database_root_password = node["imv"]["database"]["root_password"]
database_port          = node["imv"]["database"]["port"]
database_version       = node["imv"]["database"]["version"]
database_locale        = node["imv"]["database"]["locale"]
database_config        = node["imv"]["database"]["config"]
database_config_name   = node["imv"]["database"]["config_name"]
database_dump          = node["imv"]["database"]["dump"]


#####################
# installation process
#####################

apt_repository "postgresql" do
    uri "http://apt.postgresql.org/pub/repos/apt"
    components ["main", database_version]
    distribution "bionic-pgdg"
    key "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
    action :add
end

postgresql_server_install "Setup my PostgreSQL #{database_version} server" do
  setup_repo false
  version database_version
  user database_root
  password database_root_password
  port database_port
  initdb_locale database_locale
  action [:install, :create]
end

# expose service
service "postgresql"


#####################
# setup process
#####################

template "#{conf_dir(database_version)}/conf.d/#{database_config_name}.conf" do
  source "postgresql.conf.erb"
  variables(database_config: database_config)
  owner "postgres"
  group "postgres"
  mode "644"
  action :create
end

postgresql_access "Remote database md5 access for user #{database_root}" do
  access_type "host"
  access_db "all"
  access_user database_root
  access_addr "0.0.0.0/0"
  access_method "md5"
  action :grant
end

postgresql_access "Remote database md5 access for user #{database_user}" do
  access_type "host"
  access_db "all"
  access_user database_user
  access_addr "0.0.0.0/0"
  access_method "md5"
  action :grant
end

postgresql_user database_user do
  user database_root
  password database_user_password
  action :create
end

postgresql_database "create" do
  database database_name
  user database_root
  port database_port
  locale database_locale
  owner database_user
  action :create
end

cookbook_file "/tmp/#{database_dump}" do
  source database_dump
  owner "postgres"
  group "postgres"
  mode "644"
  action :create
end

execute "import sql file" do
  user "postgres"
  group "postgres"
  command "psql -U #{database_root} #{database_name} -f /tmp/#{database_dump}"
  action :run
end


#####################
# initialization process
#####################

ruby_block "reload postgresql service" do
  block do
    notifies :restart, "service[postgresql]"
  end
end
