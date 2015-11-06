#
# Cookbook Name:: iis_apps
# Recipe:: stateserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#aspnet_regiis -i

powershell_script 'install ASP.NET State Service if not already installed' do
		  code <<-EOH
		     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='ASP.NET State Service'"
		     if (!$Service) {
		        Import-Module ServerManager
				Add-WindowsFeature Web-Asp-Net
		     }
		  EOH
		  notifies :run, "windows_service['ASP.NET State Service']", :immediately
		end

#configure asp.net state service
windows_service 'ASP.NET State Service' do
  action [:stop, :configure_startup, :start]
  startup_type :automatic
end