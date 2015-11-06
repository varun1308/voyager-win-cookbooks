#
# Cookbook Name:: iis_apps
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'iis'
include_recipe 'iis::mod_aspnet45'

#install iis componenets
windows_package 'IIS URL Rewrite Module 2' do
  source node['iis_urlrewrite']['url']
  checksum node['iis_urlrewrite']['checksum']
  action :install
  notifies :restart, "service[iis]"
end

iis_section 'system.webServer/handlers' do
  section 'system.webServer/handlers'
  action :unlock
end

iis_section 'system.webServer/modules' do
  section 'system.webServer/modules'
  action :unlock
end

include_recipe 'iis::mod_compress_static'
include_recipe 'iis::mod_compress_dynamic'
include_recipe 'iis::mod_cgi'
include_recipe 'iis::mod_isapi'

#Failed request tracing rules
#Http redirect -not sure if required
#Add Server name in x-server-id to iis response headers. Voyager team has a script for it.
#setup logging directory and hourly new file creation
