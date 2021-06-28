#
# Cookbook:: imvlandau
# Recipe:: ssl
#
# Copyright:: 2021, Sufian Abu-Rab, All Rights Reserved.


###########
# variables
###########

aws_access_key_id     = node["imv"]["aws_access_key_id"]
aws_secret_access_key = node["imv"]["aws_secret_access_key"]
owner                 = node["imv"]["owner"]
group                 = node["imv"]["group"]
ssl_ca_file           = node["imv"]["ssl_ca_file"]
ssl_cert_file         = node["imv"]["ssl_cert_file"]
ssl_cert_key_file     = node["imv"]["ssl_cert_key_file"]

fail "AWS_ACCESS_KEY_ID is undefined" unless aws_access_key_id && !aws_access_key_id.empty?
fail "AWS_SECRET_ACCESS_KEY is undefined" unless aws_secret_access_key && !aws_secret_access_key.empty?


#####################
# setup process
#####################

aws_s3_file ssl_ca_file do
  bucket "imvlandau"
  remote_path "ssl/selfsigned/rootCA.pem"
  aws_access_key aws_access_key_id
  aws_secret_access_key aws_secret_access_key
  region "us-east-2"
  owner owner
  group group
  mode "600"
  action :create
end

aws_s3_file ssl_cert_file do
  bucket "imvlandau"
  remote_path "ssl/selfsigned/server.crt"
  aws_access_key aws_access_key_id
  aws_secret_access_key aws_secret_access_key
  region "us-east-2"
  owner owner
  group group
  mode "600"
  action :create
end

aws_s3_file ssl_cert_key_file do
  bucket "imvlandau"
  remote_path "ssl/selfsigned/server.key"
  aws_access_key aws_access_key_id
  aws_secret_access_key aws_secret_access_key
  region "us-east-2"
  owner owner
  group group
  mode "600"
  action :create
end
