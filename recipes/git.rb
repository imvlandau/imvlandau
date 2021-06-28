#
# Cookbook:: imvlandau
# Recipe:: git
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

aws_access_key_id     = node["imv"]["aws_access_key_id"]
aws_secret_access_key = node["imv"]["aws_secret_access_key"]
home                  = node["imv"]["home"]
owner                 = node["imv"]["owner"]
group                 = node["imv"]["group"]
git_name              = node["imv"]["git"]["name"]
git_email             = node["imv"]["git"]["email"]

fail "AWS_ACCESS_KEY_ID is undefined" unless aws_access_key_id && !aws_access_key_id.empty?
fail "AWS_SECRET_ACCESS_KEY is undefined" unless aws_secret_access_key && !aws_secret_access_key.empty?


#####################
# setup process
#####################

# prepare access to github
template "#{home}/.gitconfig" do
  source ".gitconfig.erb"
  variables(
    :NAME => git_name,
    :EMAIL => git_email
  )
  owner owner
  group group
  mode "644"
  action :create
end

directory "#{home}/.ssh" do
  owner owner
  group group
  mode "700"
  action :create
end

aws_s3_file "#{home}/.ssh/id_rsa" do
  bucket "imvlandau"
  remote_path "github_ssh_key_imvlandau.pem"
  aws_access_key aws_access_key_id
  aws_secret_access_key aws_secret_access_key
  region "us-east-2"
  owner owner
  group group
  mode "600"
  action :create
end

file "/usr/local/bin/git_wrapper.sh" do
  mode "755"
  content "#!/bin/sh\nexec /usr/bin/ssh -o \"StrictHostKeyChecking=no\" \"$@\""
  action :create
end
