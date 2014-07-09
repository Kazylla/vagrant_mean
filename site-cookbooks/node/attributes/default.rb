#
# Cookbook Name:: node
# Attribute:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

default['node'] = {
  'url' => 'http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz',
  'npm.global.packages' => 'yo grunt-cli bower generator-angular-fullstack'
}
