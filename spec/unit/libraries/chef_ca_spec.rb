#
# Cookbook: chef_ca
# Spec: libraries/chef_ca_spec
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

require 'rspec_helper'
require 'ostruct'
require 'tempfile'
include ChefCA

describe 'cacerts class' do
  context 'compute the path' do
    before do
      @name = 'Test cert'
      @bundle = test_bundle
      @path = nil
      @type = :chef
    end

    it 'should compute cacert path for mac chef' do
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      allow(cacerts).to receive(:os_type).and_return('darwin')
      expect(cacerts.cacert_path).to eq('/opt/chef/embedded/ssl/certs/cacert.pem')
    end

    it 'should compute cacert path for linux chef' do
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      allow(cacerts).to receive(:os_type).and_return('linux')
      expect(cacerts.cacert_path).to eq('/opt/chef/embedded/ssl/certs/cacert.pem')
    end

    it 'should compute cacert path for linux chefdk' do
      @type = :chefdk
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      expect(cacerts.cacert_path).to eq('/opt/chefdk/embedded/ssl/certs/cacert.pem')
    end

    it 'should compute cacert path for windows chefdk' do
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      allow(cacerts).to receive(:os_type).and_return('windows')
      expect(cacerts.cacert_path).to eq('c:/opscode/chef/embedded/ssl/certs/cacert.pem')
    end

    it 'should use the specifed cacert path' do
      @path = '/specified/cacert.pem'
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      expect(cacerts.cacert_path).to eq('/specified/cacert.pem')
    end
  end

  context 'check cert installed and install it' do
    before do
      @name = 'Test cert'
      @bundle = test_bundle
      @path = Tempfile.new('cacerts')
      @path.puts initial_cacerts
      @path.rewind
    end

    it 'should show not installed' do
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      expect(cacerts.bundle_installed?).to be_falsey
    end

    it 'should show installed' do
      cacerts = CaCerts.new(@name, @type, initial_cacerts, @path)
      expect(cacerts.bundle_installed?).to be_truthy
    end

    it 'should add the certs' do
      cacerts = CaCerts.new(@name, @type, @bundle, @path)
      cacerts.bundle_install
      expect(cacerts.bundle_installed?).to be_truthy
    end
  end
end

def test_bundle
  '-----BEGIN CERTIFICATE-----
MIIFFTCCAv2gAwIBAgIQNo9XwT6QsblLA+3qdriHZTANBgkqhkiG9w0BAQsFADAd
-----END CERTIFICATE-----'
end

def initial_cacerts
  '-----BEGIN CERTIFICATE-----
MIIFINITALCERTIBAgIQNo9XwT6QsblLA+3qdriHZTANBgkqhkiGFFFFFFFFFFFF
-----END CERTIFICATE-----'
end
