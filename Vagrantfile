# -*- mode: ruby -*-
# vi: set ft=ruby :

#############################
# Variables and configuration
#############################

# Set path for conf file
if ENV["IMVLANDAU_CONFIG"]
  configuration_filename = File.join(ENV["IMVLANDAU_CONFIG"])
else
  configuration_filename = File.join(File.dirname(__FILE__), 'config.json')
end

# Check if configration file exists
if File.exist?(configuration_filename)
  # Store settings
  configuration = JSON.parse(File.read(configuration_filename))
else
  # Return usage information and exit
  sample = File.join(File.dirname(__FILE__), 'config.sample.json')
  puts "Error: No config file found (#{configuration_filename}). To apply the default configuration:\n\n"
  puts "  cp #{sample} #{configuration_filename}"
  # Exit with error code
  exit 1
end

# Check for required Vagrant plugins
if Vagrant.has_plugin?("vagrant-berkshelf") == false
  puts "Error: Some of the required Vagrant plugins are missing:\n\n"
  puts "  vagrant plugin install vagrant-berkshelf"
  exit 1
end

# Function to check for valid JSON
def valid_json?(json)
    JSON.parse(json)
    true
rescue
    false
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # For a complete reference at
  # https://docs.vagrantup.com.

  # Boxes at https://vagrantcloud.com/search.
  # config.vm.box = "generic/ubuntu1804"

  # Disable automatic box update checking
  # config.vm.box_check_update = false

  # typing on the host "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # NOTE: This will enable public access
  config.vm.network "public_network"

  # Increase disk speed with nfs: true (Linux only)
  # config.vm.synced_folder "./", "/home/vagrant/imvlandau", nfs: true
  # https://www.admin-wissen.de/tutorials/devops-mit-vagrant-und-chef/vagrant-und-chef-performanceoptimierung
  # config.vm.synced_folder "./", "/home/vagrant/imvlandau", nfs: true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
  config.vm.synced_folder "./", "/home/vagrant/imvlandau", disabled: true

  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  # Setup and enable/disable ssh access
  # config.ssh.username = "vagrant"
  # config.ssh.password = "vagrant"
  # config.ssh.insert_key = true

  # turn off the check if the plugin is installed
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #   config.vbguest.auto_update = false
  # end

  config.vm.define "database" do |database|
    VAGRANT_DISABLE_RESOLV_REPLACE=1
    database.vm.box = "generic/ubuntu1804"
    database.vm.network "forwarded_port", guest: 5432, host: 5432, host_ip: "127.0.0.1"
    database.vm.network "forwarded_port", guest: 22,   host: 2121, host_ip: "127.0.0.1", id: "ssh", auto_correct: true
    database.vm.network "private_network", ip: configuration["imv"]["database"]["ip"]
    database.vm.provider "virtualbox" do |v|
      v.name = "database"
      v.memory = 2000
      # v.cpus = 1
    end

    ####### Provision #######
    database.vm.provision 'chef_zero' do |chef|
      chef.arguments = "--chef-license accept"
      chef.channel = "stable"
      chef.version = "15.3.14"
      # vagrant up --debug &> vagrant-database.log
      # vagrant reload --provision --debug &> vagrant-database.log
      chef.log_level = "warn" # debug (loud), info (normal), warn (quiet), and error (very quiet)
      chef.formatter = "doc"
      chef.environment = "development" # production

      chef.cookbooks_path = "./"
      chef.nodes_path = './nodes'
      chef.roles_path = "./roles"
      chef.data_bags_path = "./data_bags"
      chef.environments_path = "./environments"
      # chef.encrypted_data_bag_secret_key_path = "./.chef/id_rsa"

      chef.add_recipe "system::default"
      chef.add_recipe "system::profile"
      chef.add_recipe "line::default"
      chef.add_recipe "imvlandau::database"

      #### Override Attributes ####
      chef.json = {
        "system": configuration["imv"]["database"]["system"],
        "imv": configuration["imv"]
      }
    end
  end

  config.vm.define "api" do |api|
    api.vm.box = "generic/ubuntu1804"
    api.vm.network "forwarded_port", guest: 80, host: 8888, host_ip: "127.0.0.1"
    api.vm.network "forwarded_port", guest: 443, host: 4443, host_ip: "127.0.0.1"
    api.vm.network "forwarded_port", guest: 22,   host: 2020, host_ip: "127.0.0.1", id: "ssh", auto_correct: true
    api.vm.network "private_network", ip: configuration["imv"]["api"]["ip"]
    api.vm.provider "virtualbox" do |v|
      v.name = "api"
      v.memory = 2000
      # v.cpus = 1
    end

    ####### Provision #######
    api.vm.provision 'chef_zero' do |chef|
      chef.arguments = "--chef-license accept"
      chef.channel = "stable"
      chef.version = "15.3.14"
      # vagrant up --debug &> vagrant-api.log
      # vagrant reload --provision --debug &> vagrant-api.log
      chef.log_level = "warn" # debug (loud), info (normal), warn (quiet), and error (very quiet)
      chef.formatter = "doc"
      chef.environment = "development" # production

      chef.cookbooks_path = "./"
      chef.nodes_path = './nodes'
      chef.roles_path = "./roles"
      chef.data_bags_path = "./data_bags"
      chef.environments_path = "./environments"
      # chef.encrypted_data_bag_secret_key_path = "./.chef/id_rsa"

      chef.add_recipe "system::default"
      chef.add_recipe "system::profile"
      chef.add_recipe "line::default"
      chef.add_recipe "imvlandau::api"

      #### Override Attributes ####
      chef.json = {
        "system": configuration["imv"]["api"]["system"],
        "imv": configuration["imv"]
      }
    end
  end

  config.vm.define "client" do |client|
    client.vm.box = "generic/ubuntu1804"
    client.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
    client.vm.network "forwarded_port", guest: 8443, host: 8443, host_ip: "127.0.0.1"
    client.vm.network "forwarded_port", guest: 4444, host: 4444, host_ip: "127.0.0.1"
    client.vm.network "forwarded_port", guest: 22,   host: 2222, host_ip: "127.0.0.1", id: "ssh", auto_correct: true
    client.vm.network "private_network", ip: configuration["imv"]["client"]["ip"]
    client.vm.provider "virtualbox" do |v|
      v.name = "client"
      v.memory = 2000
      # v.cpus = 1
    end

    client.vm.provision 'chef_zero' do |chef|
      chef.arguments = "--chef-license accept"
      chef.channel = "stable"
      chef.version = "15.3.14"
      # vagrant up --debug &> vagrant-client.log
      # vagrant reload --provision --debug &> vagrant-client.log
      chef.log_level = "warn" # debug (loud), info (normal), warn (quiet), and error (very quiet)
      chef.formatter = "doc"
      chef.environment = "development" # production

      chef.cookbooks_path = "./"
      chef.nodes_path = './nodes'
      chef.roles_path = "./roles"
      chef.data_bags_path = "./data_bags"
      chef.environments_path = "./environments"
      # chef.encrypted_data_bag_secret_key_path = "./.chef/id_rsa"

      chef.add_recipe "system::default"
      chef.add_recipe "system::profile"
      chef.add_recipe "line::default"
      chef.add_recipe "imvlandau::client"

      #### Override Attributes ####
      chef.json = {
        "system": configuration["imv"]["client"]["system"],
        "imv": configuration["imv"]
      }
    end

    ####### Provision #######
    client.vm.provision "shell", run: "always", privileged: false, inline: <<-SHELL
        cd /var/www/imvlandau-client
        pm2 start pm2.config.dev.json
    SHELL
  end
end
