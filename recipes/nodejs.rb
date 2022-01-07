#
# Cookbook:: imvlandau
# Recipe:: nodejs
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


#####################
# setup process
#####################

apt_update

include_recipe "nodejs"
include_recipe "nodejs::npm"
