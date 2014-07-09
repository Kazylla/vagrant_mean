#
# Cookbook Name:: app
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# application base variables
app_env = node["app"]["env"]
app_user = node["base"]["app.user"]
app_user_home = "/home/#{app_user}"
app_base = "/#{app_user}"

# config nginx for app
template "/etc/nginx/conf.d/app.conf" do
  action :create
  source "nginx_app.conf.erb"
  notifies :reload, resources(:service => "nginx")
end
