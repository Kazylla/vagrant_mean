# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "mean"
  config.vm.box = "CentOS6.5"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140504.box"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.synced_folder "./app", "/app"
  config.vm.provision "chef_solo" do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    chef.cookbooks_path = [ "cookbooks", "site-cookbooks" ]
    chef.data_bags_path = "./data_bags"
    chef.roles_path = "./roles"
    chef.add_role "dev"
    chef.json = {
      :tz => 'Asia/Tokyo',
    }
  end
end
