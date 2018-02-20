#
# Cookbook: chef_ca
# Resource: chef_ca
# Copyright (c) 2018 Nordstrom, Inc.
#

default_action :set

property :type, Symbol, equal_to: %i(chef chefdk), required: true
property :ca_bundle, String
property :cacert_path, [String, NilClass]
include ::ChefCA

action_class do
end

action :set do
  return unless new_resource.ca_bundle
  cacerts = CaCerts.new(new_resource.name, new_resource.type, new_resource.ca_bundle, new_resource.cacert_path)
  return if cacerts.bundle_installed?
  converge_by("Chef_ca add bundle #{new_resource.name} to #{cacerts.cacert_path}") do
    cacerts.bundle_install
  end
end
