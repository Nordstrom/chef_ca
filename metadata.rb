name             'chef_ca'
maintainer       'Nordstrom, INC.'
maintainer_email 'itcpmall@nordstrom.com'
license          'Apache-2.0'
description      'Adds a certificate bundle to the chef or chefdk cacert file'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'
chef_version     '>= 12.10' if respond_to?(:chef_version)

issues_url       'https://github.com/nordstrom/chef_ca/issues'
source_url       'https://github.com/nordstrom/chef_ca'
supports         'redhat'
supports         'windows'
supports         'macos'
