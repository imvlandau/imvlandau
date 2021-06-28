#
# Cookbook:: imvlandau
# Recipe:: apache2
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

api_port = node["imv"]["api"]["port"]
user     = node["imv"]["user"]
group    = node["imv"]["group"]


#####################
# installation process
#####################

apache2_install "imv-apache2" do
  listen [ api_port, 443 ]
  # https://www.linode.com/docs/web-servers/apache-tips-and-tricks/tuning-your-apache-server/
  mpm "prefork"
  apache_user user
  apache_group group
  action :install
end

apt_repository "php7" do
    uri "ppa:ondrej/php"
    components ["main"]
    distribution "bionic"
    action :add
end

apt_package [
      "libapache2-mod-php7.2",
      "libqdbm14",
      "libssl1.1",
      "php7.2",
      "php7.2-cli",
      "php7.2-common",
      "php7.2-curl",
      "php7.2-gd",
      "php7.2-json",
      "php7.2-mbstring",
      "php7.2-opcache",
      "php7.2-readline",
      "php7.2-xml",
      "php7.2-cgi",
      "php7.2-fpm",
      "php7.2-sqlite3",
      "php7.2-pgsql",
      "php7.2-intl",
      "php7.2-dev",
      "php-pear",
      "file",
      "git",
      "unzip",
      "zip"
    ] do
    action :install
end

service "apache2" do
  extend Apache2::Cookbook::Helpers
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module "deflate"
apache2_module "headers"
apache2_module "rewrite"
apache2_module "ssl"
apache2_module "php7.2" do
  identifier "php7_module"
  mod_name "libphp7.2.so"
end

# just adopted this from the example at
# https://github.com/sous-chefs/apache2/blob/master/test/cookbooks/test/recipes/mod_ssl.rb
apache2_mod_ssl ""
