#
# Cookbook Name:: iis_apps
# Recipe:: stateserver
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#aspnet_regiis -i

powershell_script 'install ASP.NET State Service if not already installed' do
		  code <<-EOH
		     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='aspnet_state'"
		     if (!$Service) {
		        Import-Module ServerManager
				Add-WindowsFeature Web-Asp-Net
		     }
		  EOH
		  notifies :configure_startup, "windows_service[aspnet_state]", :immediately
		end

#configure asp.net state service
windows_service 'aspnet_state' do
  action [:stop, :configure_startup, :start]
  startup_type :automatic
end