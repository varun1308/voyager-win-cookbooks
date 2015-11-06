#
# Cookbook Name:: iis_apps
# Recipe:: routing
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug

require 'net/http'
include_recipe 'route53'

#get all stacks
stacks = search(:aws_opsworks_stack) rescue []

stacks.each do |stack|
	Chef::Log.debug "Found stack: #{stack[:name]}"
end

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

#get all instances in the stack
instances = search(
	  :aws_opsworks_instance
	) rescue []

regions = []
instances.each do |instance|
	Chef::Log.debug "Found instance: #{instance[:hostname]} in availability zone: #{instance[:availability_zone]}"
	availability_zone = instance[:availability_zone]
	region = availability_zone[0,availability_zone.length-1]
	unless !regions.include?(region)
		regions << region
		Chef::Log.debug "Added region: #{region}"
	end
end

#find all load balances in the regions
regions.each do |region|
	client = Aws::OpsWorks::Client.new(region: region)
	resp = client.describe_elastic_load_balancers({
		stack_id: search(:aws_opsworks_stack) .first
		}) 
	if resp
		resp.elastic_load_balancers.each do |elb|
			Chef::Log.debug "Found elb: #{elb.elastic_load_balancer_name} with dns_name: #{elb.dns_name} and layer_id #{elb.layer_id}"
		end
	end

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