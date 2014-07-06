#
# Cookbook Name:: mongo
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/yum.repos.d/mongodb.repo" do
  source "mongodb.repo"
  mode 0755
  owner "root"
  group "root"
end

# install mongodb
package "mongodb-org"

# nginx resource
service "mongod" do
  action [ :enable, :start ]
  supports :reload=> true, :restart => true
end
