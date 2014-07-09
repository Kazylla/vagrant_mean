#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

cache_path = Chef::Config['file_cache_path']
pkgname = File.basename(node["node"]["url"], ".tar.gz")

src_filepath = "#{cache_path}/#{pkgname}.tgz"
extract_path = "#{cache_path}/#{pkgname}"

# fetch tgz
remote_file src_filepath do
  source node["node"]["url"]
  action :create
  notifies :run, "bash[extract_node_js_tgz]", :immediately
  not_if "which node"
end

# extract tgz
bash "extract_node_js_tgz" do
  action :nothing
  code <<-EOH
    tar xzf #{src_filepath} -C #{cache_path}
    EOH
  notifies :run, "bash[install_node_js]", :immediately
end

# install
bash "install_node_js" do
  action :nothing
  cwd extract_path
  code <<-EOH
    rm ChangeLog LICENSE README.md
    cp -pr * /usr/.
    EOH
  notifies :run, "bash[install_global_packages]", :immediately
end

# install node packages from npm
bash "install_global_packages" do
  action :nothing
  code <<-EOH
    npm install -g #{node["node"]["npm.global.packages"]}
    EOH
end
