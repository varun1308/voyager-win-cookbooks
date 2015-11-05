actions :add
default_action :add

attribute :website_name, :name_attribute => true, :kind_of => String, :required => true
attribute :website_source, :kind_of => String, :required => true
attribute :host_header, :kind_of => String
attribute :port, :kind_of => Fixnum, :default => 80
attribute :protocol, :kind_of => Symbol, :equal_to => [:http, :https],  :default => :http
attribute :website_base_directory, :kind_of => String, :default => "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot"
attribute :runtime_version, :kind_of => String, :default => "4.0"
attribute :scm, :kind_of => Hash, :required => true
attribute :new_web_config, :kind_of => String
attribute :should_replace_web_config, :kind_of => [TrueClass, FalseClass], :default => false
attribute :web_erb_config, :kind_of => String
attribute :web_config_params, :kind_of => Hash