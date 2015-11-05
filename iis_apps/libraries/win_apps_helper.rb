require "uri"

module Tavisca
  module WinApps
    module Helper
      def self.parse_uri(uri)
        uri = URI.parse(uri)
        
        uri_path_components = uri.path.split("/").reject{|p| p.empty?}
        
        virtual_host_match = uri.host.match(/\A((.+)\.)?s3(?:-(?:ap|eu|sa|us)-.+-\d)?\.amazonaws\.com/i)
        
        bucket = uri_path_components[0]
        remote_path = uri_path_components[1..-1].join("/")
        file_name = uri_path_components[-1]
        [file_name, bucket, remote_path, virtual_host_match[0]]
      end
    end
  end
end
