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
  'npm.global.packages' => 'express-generator@4 forever supervisor',
  'npm.yeoman.packages' => 'yo grunt-cli bower',
  'npm.generator.packages' => 'generator-angular-fullstack'
}
