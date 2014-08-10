#
# Cookbook Name:: nginx
# Attribute:: default
#
# Copyright 2014, Kazylla
#
# All rights reserved - Do Not Redistribute
#

default['nginx'] = {
  'worker.processes' => 4,
  'worker.connections' => 1024,
  'keepalive.timeout' => 65,
  'package' => {
    'nginx' => {
      'version' => '>= 1.6.0',
      'repo' => 'nginx'
    }
  }
}
