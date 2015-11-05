#
# Cookbook Name:: iis_apps
# Recipe:: travelnxt
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug


apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "travelnxt"}
if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming travelnxt website is same."

	win_apps_website node['travelnxt']['site_name'] do
	  host_header node['travelnxt']['host_header']
	  port node['travelnxt']['port']
	  protocol node['travelnxt']['protocol']
	  website_base_directory node['travelnxt']['site_base_directory']
	  runtime_version node['travelnxt']['runtime_version']
	  scm app["app_source"]
	  should_replace_web_config node['travelnxt']["should_replace_web_config"]
	  new_web_config node['travelnxt']["new_web_config"]
	  web_erb_config node['travelnxt']["web_config_erb"]
	  web_config_params node['travelnxt']["web_config_params"]
	  action :add
	end
else
	Chef::Log.debug "travelnxt website not found in apps to deploy."
end
