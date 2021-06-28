#
# Cookbook:: imvlandau
# Recipe:: nodejs
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


#####################
# setup process
#####################

bash "install nodejs" do
  cwd "/tmp"
  code <<-EOH
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt install nodejs -y
  EOH
  user "root"
  group "root"
  action :run
end
