#
# Cookbook:: imvlandau
# Recipe:: bashrc
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

home  = node["imv"]["home"]
user  = node["imv"]["user"]
owner = node["imv"]["owner"]
group = node["imv"]["group"]


#####################
# setup process
#####################

# add bashrc_local and update bashrc for user root
template "/root/.bashrc_local" do
  owner "root"
  group "root"
  mode  "644"
  source "bashrc_local.erb"
  action :create
end
append_if_no_line "add bashrc_local to /root/.bashrc" do
  path "/root/.bashrc"
  line "if [ -f /root/.bashrc_local ]; then . /root/.bashrc_local; fi"
  action :edit
end
bash "/root/.bashrc" do
  code 'source /root/.bashrc'
  action :run
end

# add bashrc_local and update bashrc for user vagrant
template "#{home}/.bashrc_local" do
  owner owner
  group group
  mode  "644"
  source "bashrc_local.erb"
  action :create
end
append_if_no_line "add bashrc_local to #{home}/.bashrc" do
  path "#{home}/.bashrc"
  line "if [ -f #{home}/.bashrc_local ]; then . #{home}/.bashrc_local; fi"
  action :edit
end
bash "#{home}/.bashrc" do
  code "source #{home}/.bashrc"
  user user
  group group
  environment ({"HOME" => home, "USER" => user})
  action :run
end
