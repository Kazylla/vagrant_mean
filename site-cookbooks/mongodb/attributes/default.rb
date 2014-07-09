#
# Cookbook Name:: mongodb
# Attribute:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

default['mongodb'] = {
  'package' => {
    'mongodb' => {
      'version' => '2.4.6-1.el6',
      'repo' => 'epel'
    },
    'mongodb-server' => {
      'version' => '2.4.6-1.el6',
      'repo' => 'epel'
    }
  }
}
