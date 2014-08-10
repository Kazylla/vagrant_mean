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
    'mongodb-org' => {
      'version' => '>= 2.6.4',
      'repo' => 'mongodb'
    }
  }
}
