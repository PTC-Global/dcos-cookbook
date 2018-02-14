module Dcos
  # Helper functions
  module Helpers
    def dcos_generate_config_url
      return node['dcos']['dcos_generate_config_url'] if node['dcos'].key?('dcos_generate_config_url')
      case node['dcos']['dcos_version']
      when 'EarlyAccess', 'earlyaccess'
        "#{dcos_base_url}/dcos_generate_config.sh"
      else
        "#{dcos_base_url}/commit/#{dcos_commit_id}/dcos_generate_config.sh"
      end
    end

    private

    def dcos_base_url
      case node['dcos']['dcos_version']
      when '1.10.1', '1.10.0', '1.9.5', '1.9.4', '1.9.3', '1.9.2', '1.9.1', '1.8.9'
        "https://downloads.dcos.io/dcos/stable/#{node['dcos']['dcos_version']}"
      when 'EarlyAccess', 'earlyaccess'
        'https://downloads.dcos.io/dcos/EarlyAccess'
      else # stable or older releases
        'https://downloads.dcos.io/dcos/stable'
      end
    end

    def dcos_commit_id
      case node['dcos']['dcos_version']
      when 'stable', '1.10.1'
        'd932fc405eb80d8e5b3516eaabf2bd41a2c25c9f'
      when '1.10.0'
        'e38ab2aa282077c8eb7bf103c6fff7b0f08db1a4'
      when '1.9.5'
        '4308d88bfc0dd979703f4ef500ce415c5683b3c5'
      when '1.9.4'
        'ff2481b1d2c1008010bdc52554f872d66d9e5904'
      when '1.9.3'
        '744f5ea28fc52517e344a5250a5fd12554da91b8'
      when '1.9.2'
        'af6ddc2f5e95b1c1d9bd9fd3d3ef1891928136b9'
      when '1.9.1'
        '008d3bfe4acca190100fcafad9a18a205a919590'
      when '1.9.0'
        '0ce03387884523f02624d3fb56c7fbe2e06e181b'
      when '1.8.9'
        '65d66d7f399fe13bba8960c1f2c42ef9fa5dcf8d'
      when '1.8.8'
        '602edc1b4da9364297d166d4857fc8ed7b0b65ca'
      when '1.8.7'
        '1b43ff7a0b9124db9439299b789f2e2dc3cc086c'
      end
    end
  end
end

Chef::Recipe.send(:include, Dcos::Helpers)
Chef::Resource.send(:include, Dcos::Helpers)
