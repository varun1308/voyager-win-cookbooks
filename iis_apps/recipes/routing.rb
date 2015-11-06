#
# Cookbook Name:: iis_apps
# Recipe:: routing
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug

require 'net/http'
include_recipe 'route53'

#get all layers in stack
layers = search(
	  :aws_opsworks_layer
	) rescue []

layers.each do |layer|
	Chef::Log.debug "Found layer: #{layer[:name]}"
end

#get all load balancers in stack
region = node["opsworks"]["instance"]["region"]
Chef::Log.debug "Found region: #{region}"

elbs = search(
	  :aws_opsworks_layer
	) rescue []

layers.each do |layer|
	Chef::Log.debug "Found layer: #{layer[:name]}"
end

#for each load balancer/elb pair, create routing for elb

# route53_record "create a record for each service layer" do
#   name  node["opsworks"]["instance"]["layers"][0] + '.' + node[:route53]["domain"]
#   value node["opsworks"]["instance"]["private_ip"] #Net::HTTP.get(URI.parse('http://169.254.169.254/latest/meta-data/public-ipv4'))
#   type  "A"
#   ttl   60
#   zone_id               node[:route53][:dns_zone_id]
#   #aws_access_key_id     node[:custom_access_key]
#   #aws_secret_access_key node[:custom_secret_key]
#   overwrite true
#   action :create
# end