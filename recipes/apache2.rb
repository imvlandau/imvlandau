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
      "libapache2-mod-php7.4",
      "libqdbm14",
      "libssl1.1",
      "php7.4",
      "php7.4-cli",
      "php7.4-common",
      "php7.4-curl",
      "php7.4-gd",
      "php7.4-json",
      "php7.4-mbstring",
      "php7.4-opcache",
      "php7.4-readline",
      "php7.4-xml",
      "php7.4-cgi",
      "php7.4-fpm",
      "php7.4-sqlite3",
      "php7.4-pgsql",
      "php7.4-intl",
      "php7.4-dev",
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
apache2_module "php7.4" do
  identifier "php7_module"
  mod_name "libphp7.4.so"
end

# just adopted this from the example at
# https://github.com/sous-chefs/apache2/blob/master/test/cookbooks/test/recipes/mod_ssl.rb
apache2_mod_ssl ""
