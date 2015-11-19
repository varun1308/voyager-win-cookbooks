#
# Cookbook Name:: other_apps
# Recipe:: routing_services
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
Chef::Log.level = :debug

require 'net/http'
include_recipe 'route53'

#get all routing cnames names/ip records to be mapped from statebags.
#format 
	# {
	# 	"routing_services" : {
	# 		"zone_id" : "1111",
	# 		"records" : {
	# 			"CNAME" : {
	# 				"elb.aws.com" : [
	# 					"logs",
	# 					"services",
	# 					"air"
	# 				],
	# 				"elb2.aws.com" : [
	# 					"logs2",
	# 					"services2",
	# 					"air2"
	# 				]
	# 			},
	# 			"A" : {
	# 				"192.168.0.1" : [
	# 					"logs",
	# 					"services",
	# 					"air"
	# 				],
	# 			}
	# 		}
	# 	}
	# }
zone_id = data_bag_item('routing_services', 'zone_id') rescue {}
records = data_bag_item('routing_services', 'records') rescue {}

env = ''
if node["env"]
	env = node["env"] + '-'
end

Chef::Log.debug "Found CNAME: #{records['CNAME']}"

#for CNAME and A records, add routes

records['CNAME'].each do |key, values|
	values.each do |value|
		Chef::Log.debug "Found record: #{key}, #{value}"
		#prepend env indicator to records
		#update route53 entries for all record pairs
		route53_record "create a record for #{value}" do
		  name  	"#{env}#{value}"
		  value 	key
		  type  	'CNAME'
		  ttl		60
		  zone_id 	zone_id["id"]
		  #aws_access_key_id     node[:custom_access_key]
		  #aws_secret_access_key node[:custom_secret_key]
		  overwrite true
		  action :create
		end
	end
end

records['A'].each do |key, values|
	values.each do |value|
		Chef::Log.debug "Found record: #{key}, #{value}"
		
		#prepend env indicator to records
		#update route53 entries for all record pairs
		route53_record "create a record for #{value}" do
		  name  	"#{env}#{value}"
		  value 	key
		  type  	'A'
		  ttl		60
		  zone_id 	zone_id["id"]
		  #aws_access_key_id     node[:custom_access_key]
		  #aws_secret_access_key node[:custom_secret_key]
		  overwrite true
		  action :create
		end
	end
end

