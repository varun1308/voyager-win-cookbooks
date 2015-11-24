#travelnxt website attributes
default['travelnxt']['site_name'] = 'travelnxt'
default['travelnxt']['host_header'] = ''
default['travelnxt']['port'] = 80
default['travelnxt']['protocol'] = :http
default['travelnxt']['runtime_version'] = '4.0'
default['travelnxt']['site_base_directory'] = "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot"
default['travelnxt']["should_replace_web_config"] = false
default['travelnxt']["new_web_config"] = nil
default['travelnxt']["web_config_erb"] = nil
default['travelnxt']["web_config_params"] = Hash.new
default['travelnxt']['build_number'] = 20

#url rewrite attributes
default['iis_urlrewrite']['url'] = 'http://download.microsoft.com/download/6/7/D/67D80164-7DD0-48AF-86E3-DE7A182D6815/rewrite_2.0_rtw_x64.msi'
default['iis_urlrewrite']['checksum'] = 'd9722381f3025bfd4d0f9006d6e33301be5907545801a48b6c082ce1465c5676'

default['aws']['aws_sdk_version'] = '~> 2.1.34'
