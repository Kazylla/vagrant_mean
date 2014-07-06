#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# install rpm
epel_filepath = "#{Chef::Config['file_cache_path']}/epel.rpm"
remote_file epel_filepath do
  source "http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm"
  action :create
  notifies :run, "package[epel]", :immediately
end
package "epel" do
  action :install
  provider Chef::Provider::Package::Rpm
  source epel_filepath
end

# install node.js
package "nodejs"
package "npm"
