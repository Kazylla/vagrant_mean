#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

# application base variables
app_env = node['base']['app.env']
app_user = node['base']['app.user']
app_user_home = "/home/#{app_user}"
app_base = "/#{app_user}"
app_root = "#{app_base}/#{node['base']['app.name']}"
deploy_root = "#{app_user_home}/#{node['base']['app.name']}"

# instance type (vagrant or various ec2 instance types)
instance_type = "vagrant"
if not node[:ec2].nil?
  instance_type = node[:ec2][:instance_type]
end
log "instance type is #{instance_type}"

# set localtime
file "set localtime" do
  action :create
  path "/etc/localtime"
  content lazy { File.open("/usr/share/zoneinfo/#{node[:base][:localtime]}").read }
  only_if { not node[:base][:localtime].nil? and File.exists?("/usr/share/zoneinfo/#{node[:base][:localtime]}") }
end

# create swapfile on every rhel instance
swap_size = node['base']['swap.size']
bash 'create swapfile' do
  user 'root'
  code <<-EOC
    dd if=/dev/zero of=/swap.img bs=1M count=#{swap_size} &&
    chmod 600 /swap.img
    mkswap /swap.img
  EOC
  only_if { not node[:ec2].nil? }
  only_if "test ! -f /swap.img -a `cat /proc/swaps | wc -l` -eq 1"
end
mount '/dev/null' do # swap file entry for fstab
  action :enable # cannot mount; only add to fstab
  device '/swap.img'
  fstype 'swap'
end
bash 'activate swap' do
  code 'swapon -ae'
  only_if "test `cat /proc/swaps | wc -l` -eq 1"
end

# iptables config
iptables_rule "iptables_http"
iptables_rule "iptables_ssl"
iptables_rule "iptables_ssh"

# install git
package "git"

# add users
data_ids = data_bag('users')

data_ids.each do |id|
  u = data_bag_item('users', id)
  # add user
  user u['id'] do
    shell    u['shell']
    password u['password']
    supports :manage_home => true, :non_unique => false
    action   [:create]
  end
  # create .ssh directory
  directory "/home/#{id}/.ssh" do
    owner u['id']
    group u['id']
    mode 0700
    action :create
  end
  # private key for GitHub
  file "/home/#{id}/.ssh/id_rsa_git" do
    owner u['id']
    group u['id']
    mode  0600
    content u['key']
    action :create_if_missing
  end
  # public key for GitHub
  file "/home/#{id}/.ssh/id_rsa_git.pub" do
    owner u['id']
    group u['id']
    mode  0620
    content u['pubkey']
    action :create_if_missing
  end
  # configure git
  file "/home/#{id}/.gitconfig" do
    owner u['id']
    group u['id']
    mode  0620
    content "[user]\n\tname = #{u['git.name']}\n\temail = #{u['git.email']}"
    action :create_if_missing
  end
  # set ssh.config
  cookbook_file "/home/#{id}/.ssh/config" do
    source "ssh.config"
    mode 0600
    owner u['id']
    group u['id']
  end
  # rewrite .bashrc
  bashrc_path = "/home/#{u['id']}/.bashrc"
  template "rewrite .bashrc" do
    action :create
    path bashrc_path
    source "bashrc.erb"
    mode 0644
    owner u['id']
    group u['id']
    variables({
      :app_root => app_root,
      :deploy_root => deploy_root
    })
  end
end

# add sudoers configuration for application user
sudo "app" do
  user "app"
  runas "ALL"
  commands [ "/sbin/service nginx restart", "/sbin/service php-fpm restart" ]
  host "ALL"
  nopasswd true
end

# [development] mount shared app folder
if instance_type == "vagrant" && app_env == "development"
  execute "mount #{app_base}" do
    command "mount -t vboxsf -o uid=`id -u #{app_user}`,gid=`id -g #{app_user}` #{app_base} #{app_base}"
    action :nothing
  end
  execute "umount #{app_base}" do
    command "umount #{app_base}"
    notifies :run, "execute[mount #{app_base}]", :immediately
    only_if { File.directory?(app_base) && Etc.getpwuid(File.stat(app_base).uid).name != app_user }
  end
# [production] create app folder
else
  directory app_base do
    owner app_user
    group app_user
    action :create
  end
end

