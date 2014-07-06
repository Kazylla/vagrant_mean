#
# Cookbook Name:: base
# Attribute:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

default['base'] = {
  'localtime' => 'UTC',
  'hostname' => 'localhost',
  'swap.size' => 2048,
  'app.user' => 'app',
  'app.name' => 'example',
  'app.env' => 'development',
  'app.repos' => 'git@github.com:kazylla/example.git'
}
