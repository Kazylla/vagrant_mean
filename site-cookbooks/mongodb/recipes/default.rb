#
# Cookbook Name:: mongo
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# add mongodb yum repository
cookbook_file "/etc/yum.repos.d/mongodb.repo" do
  source "mongodb.repo"
  mode 0755
  owner "root"
  group "root"
end

# install mongodb
node['mongodb']['package'].each_pair do |p,info|
  package_and_version = p
  if info.include?('version')
    package_and_version += " #{info['version']}"
  end
  if info.include?('repo')
    yum_package package_and_version do
      action :install
      options "--enablerepo=#{info['repo']}"
    end
  else
    yum_package package_and_version
  end
end

# mongodb resource
service "mongod" do
  action [ :enable, :start ]
  supports :reload=> true, :restart => true
end
