#
# Cookbook:: imvlandau
# Recipe:: default
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


#####################
# setup process
#####################

directory "/var/www" do
  owner "root"
  group "root"
  mode "755"
  action :create
end
