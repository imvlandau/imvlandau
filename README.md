# imvlandau chef cookbook and recipes

Installs/Configures IMVLandau client, database and api server

## Install instruction

First install Vagrant and VirtualBox on your OS

### Virtual Box

[Virtual Box](https://www.virtualbox.org/) is a hyper visor for x86 hardware. It's an application that runs on your computer (referred to as the "host") that runs virtual machines. Virtual machines allow you to simulate an entire virtual server on your desktop or laptop.

### Vagrant

[Vagrant](http://www.vagrantup.com/) is an automation wrapper for starting up and provisioning virtual servers. It is used to automate virtual machine creation. It can be used with a number of virtualization platforms, one of which is Virtual Box.

Vagrant makes it easy to reproducibly run the same build process to provision a server. It also provides a simple way to forward ports on the virtual server to your local machine.

### Required plugins for Vagrant

First install the chef development kit (not client). You have to fill out a formular in order to start the download.

[https://downloads.chef.io/tools/download/chefdk](https://downloads.chef.io/tools/download/chefdk)

Afterwards install the vargrant-berkshelf plugin with
```
vagrant plugin install vagrant-berkshelf
```

### Add a configuration file to the root folder

Lastly add a copy of the sample configuration file to the root folder (same folder where the sample is), rename it to `config.json` and replace the sample secret tokens inside of it.


Once you have both Virtual Box and Vagrant installed you can spin up virtual machines using vagrant by simply running `vagrant up`. This command looks in your current directory for a file name `Vagrantfile` that describes the configuration and provisioning of the virtual machine.

Run within the terminal (f. e. git bash with mingw/cygwin installed, and binary-/system path correctly set) in the root folder following command:

`vagrant up`

### Add the private SSH access key for this repository into the root folder of this project

Place the private SSH access pem-file (in OpenSSH format) called `github_ssh_key_imvlandau.pem` into the root directory. Open a terminal, navigate to the root of your local repository and execute following command:

`git config core.sshCommand "ssh -i github_ssh_key_imvlandau.pem"`

otherwise follow the instructions of this page in order to configure a global github credentials file:

[https://gist.github.com/jexchan/2351996](https://gist.github.com/jexchan/2351996)



## Development

Use following command for debugging

### debug infos
```
output="#{Chef::JSONCompat.to_json_pretty(node.to_hash)}"
```

#### dump node data to console with
```
Chef::Log.info(output)
```

#### write to file with
```
file '~/node.json' do
  content output
end
```

#### access aws opsworks databags with
```
app = search("aws_opsworks_app")
Chef::Log.info(Chef::JSONCompat.to_json_pretty(app))
```

#### access first of local databags called "user" with
```
app = search("user").first
Chef::Log.info(Chef::JSONCompat.to_json_pretty(app))
```

#### access local databag item called "john" in databag "user" with
```
app = data_bag_item("user", "john")
Chef::Log.info(Chef::JSONCompat.to_json_pretty(app))
```

## Contributing

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

1. **Fork** the repo on GitHub
2. **Clone** the project to your own machine
3. **Commit** changes to your own branch
4. **Push** your work back up to your fork
5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Contributors

1. Sufian Abu-Rab
