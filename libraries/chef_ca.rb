#
# Cookbook: chef_ca
# Library: chef_ca
#
# Copyright:: 2018 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# ChefCA name space
module ChefCA
  # Mange the certificate bundles in the chef cacert.pem file
  class CaCerts
    require 'tempfile'

    def initialize(name, type, bundle, path)
      @name = name
      @type = type
      @type = 'chef-workstation' if type == 'chefworkstation'
      @bundle = bundle
      @path = path
      @os = os_type
    end

    def bundle_install
      temp_cacert = Tempfile.open('cacert', cacert_dir)
      temp_cacert.puts cacert_contents
      temp_cacert.puts "Cert Bundle - #{@name}"
      temp_cacert.puts '==========================='
      temp_cacert.puts @bundle
      temp_cacert.close
      mover = Chef::FileContentManagement::Deploy.strategy(true)
      mover.deploy(temp_cacert.path, cacert_path)
    end

    def bundle_installed?
      chef_cacert_pem = ::File.read(cacert_path)
      chef_cacert_pem.include?(@bundle)
    end

    def cacert_contents
      File.read(cacert_path)
    end

    def cacert_dir
      File.dirname(cacert_path)
    end

    def cacert_path
      @path || @path = computed_cacert_path
    end

    def computed_cacert_path
      # linux, mac(darwin), solaris
      return "/opt/#{@type}/embedded/ssl/certs/cacert.pem" if os_type =~ /linux|darwin|solaris/
      # windows
      return "c:/opscode/#{@type}/embedded/ssl/certs/cacert.pem" if os_type =~ /windows|mingw/
      raise "chef-ca unsupported os type #{os_type}"
    end

    def os_type
      @os || RbConfig::CONFIG['host_os'].downcase
    end
  end
end
