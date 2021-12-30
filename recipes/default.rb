#
# Cookbook:: imvlandau
# Recipe:: default
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

owner = node["imv"]["owner"]
group = node["imv"]["group"]


#####################
# setup process
#####################

directory "/var/www" do
  owner owner
  group group
  mode "755"
  action :create
end
