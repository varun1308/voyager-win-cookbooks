def whyrun_supported?
  true
end

use_inline_resources

action :add do

	run_context.include_recipe 'aws'
	
	website_directory = "#{new_resource.website_base_directory}\\#{new_resource.website_name}"
	
	app_pool_name = new_resource.website_name
	# Download the built application and unzip it to the app directory.

	app_checkout = Chef::Config["file_cache_path"] + "\\#{new_resource.website_name}"

	Chef::Log.debug "Downloading app source file using info #{new_resource.scm}."

	#parse scm info	
	if new_resource.scm[:type].empty? || new_resource.scm[:type] != 's3'
		Chef::Log.error "Error: No s3 configuration found in scm parameter."
        raise Chef::Exceptions::UnsupportedAction "#{self.to_s} does not support repository types other than s3"

	else
		file_name, bucket, remote_path, url = Tavisca::WinApps::Helper.parse_uri(new_resource.scm[:url])

		#download file from s3
		aws_s3_file ::File.join(Chef::Config["file_cache_path"],file_name) do
		  bucket bucket
		  remote_path remote_path
		  aws_access_key_id new_resource.scm[:user]
		  aws_secret_access_key new_resource.scm[:password]
		end


		#unzip file to destination
		windows_zipfile app_checkout do
		  source ::File.join(Chef::Config["file_cache_path"],file_name)
		  action :unzip
		end

		#do web.config modifications
		if new_resource.should_replace_web_config
			Chef::Log.debug "Moving file #{new_resource.new_web_config}."
			powershell_script 'copy_web_config' do
			  code <<-EOH 
			     Copy-Item "#{app_checkout}\\#{new_resource.new_web_config}" "#{app_checkout}\\web.config" -Force
			  EOH
			end
		else
			unless new_resource.web_erb_config.nil? || new_resource.web_erb_config.empty? 
				Chef::Log.debug "web.config params #{new_resource.web_config_params}."

			 	template "#{app_checkout}\\web.config" do
			 	  local true
				  source "#{app_checkout}\\#{new_resource.web_erb_config}"
				  variables(
				  		:web_config_params => new_resource.web_config_params
				  )
				end
		 	
			else
				Chef::Log.debug "Did not find any web config replacement configuration."
			end
		end

		#move directory to destination
		if ::Dir.exist?(website_directory)
			#delete existing directory
			directory website_directory do
				recursive true
				action :delete
			end
		end
		
		#move extracted files to website directory
		# Copy app to deployment directory
		execute "copy #{new_resource.website_name}" do
			command "Robocopy.exe #{app_checkout} #{website_directory} /MIR /XF .gitignore /XF web.config.erb /XD .git"
			returns [0, 1, 3]
		end

		# Create the site app pool.
		iis_pool  new_resource.website_name do
		  runtime_version new_resource.runtime_version
		end

		# Create the site directory and give IIS_IUSRS read rights.
		directory website_directory do
		  rights :read, 'IIS_IUSRS'
		  recursive true
		  action :create
		end

		# Create the iis site.
		iis_site new_resource.website_name do
		  protocol new_resource.protocol
		  port new_resource.port
		  path website_directory
		  application_pool new_resource.website_name
		  host_header new_resource.host_header
		  action [:add, :start]
		end	

	end

end