# -*- encoding: utf-8 -*-

#
# Cookbook Name:: devops_library
# Recipe:: default
#
# Copyright 2015, http://DennyZhang.com
#
# Apache License, Version 2.0
#

# enable bash alias
cookbook_file '/etc/profile.d/mybackup.sh' do
  source 'mybackup.sh'
  owner 'root'
  group 'root'
  mode 0o755
end
