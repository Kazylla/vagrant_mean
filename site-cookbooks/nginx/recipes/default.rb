#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# add nginx yum repository
cookbook_file "/etc/yum.repos.d/nginx.repo" do
  source "nginx.repo"
  mode 0755
  owner "root"
  group "root"
end

# install nginx
node['nginx']['package'].each_pair do |p,info|
  yum_package p do
    action :install
    version info['version']
    options "--enablerepo=#{info['repo']}"
  end
end

# instance type (vagrant or various ec2 instance types)
instance_type = "vagrant"
if not node[:ec2].nil?
  instance_type = node[:ec2][:instance_type]
end

# generate sample ssl certification file
ssl_certfile_dir = "/etc/nginx/ssl"
ssl_samplecert_expired = 36500
ssl_samplecert_key = "ssl.key"
ssl_samplecert_crt = "ssl.crt"
ssl_samplecert_subject = "/C=JP/ST=Kanagawa/L=Yokohama/O=Kazylla/CN=#{node["base"]["hostname"]}/"
bash "generate ssl certfile" do
  code <<-EOH
    mkdir #{ssl_certfile_dir}
    cd #{ssl_certfile_dir}
    openssl req -new -days #{ssl_samplecert_expired} -x509 -nodes \
      -keyout #{ssl_samplecert_key} -out #{ssl_samplecert_crt} -subj "#{ssl_samplecert_subject}"
    EOH
    not_if { File.exists?(ssl_certfile_dir) }
end

# nginx resource
service "nginx" do
  action [ :enable, :start ]
  supports :reload=> true, :restart => true
end

# config nginx
nginx_conf = "/etc/nginx/nginx.conf"
ruby_block "rename nginx original nginx.conf" do
  block do
    File.rename(nginx_conf, "#{nginx_conf}.orig")
  end
  not_if { File.exists?("#{nginx_conf}.orig") }
end
template "/etc/nginx/nginx.conf" do
  action :create
  source "nginx.conf.erb"
  variables({
    :instance_type => instance_type
  })
  notifies :reload, resources(:service => "nginx")
end

# config nginx applications
nginx_default_conf = "/etc/nginx/conf.d/default.conf"
ruby_block "rename nginx default.conf" do
  block do
    File.unlink("#{nginx_default_conf}.orig")
    File.rename(nginx_default_conf, "#{nginx_default_conf}.orig")
  end
  only_if { File.exists?(nginx_default_conf) }
end

# delete /etc/init.d/httpd
file "/etc/init.d/httpd" do
  action :delete
end

# delete index.html
file "/usr/share/nginx/html/index.html" do
  action :delete
end
