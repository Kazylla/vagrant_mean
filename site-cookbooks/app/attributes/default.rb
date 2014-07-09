#
# Cookbook Name:: app
# Attribute:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

default['app'] = {
  'names' => {
    'web' => {
      'git' => 'git@github.com:kazylla/web.git',
      'port' => 3000
    },
    'api' => {
      'git' => 'git@github.com:kazylla/api.git',
      'port' => 3001
    },
  },
  'static' => 'web'
}
