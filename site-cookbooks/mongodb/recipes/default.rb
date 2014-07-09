#
# Cookbook Name:: mongo
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# install mongodb
node['mongodb']['package'].each_pair do |p,info|
  yum_package p do
    action :install
    version info['version']
    options "--enablerepo=#{info['repo']}"
  end
end

# mongodb resource
service "mongod" do
  action [ :enable, :start ]
  supports :reload=> true, :restart => true
end
