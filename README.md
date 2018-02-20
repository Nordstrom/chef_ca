# chef_ca

Chef client code uses a private list of certificate authority credentials.  This cookbook will add a supplied bundle to the chef cacert.pem file.

# Resource

chef_ca
======

Actions
-------
*  set - adds the credentials to the cacert.pem file

Properties
*  chef_type - chef client or chefdk. Allowed values are :chef for :chefdk
*  ca_bundle - cer (X.509, base 64 encode)  format bundle to add to the cacert.pem file
*  cacert_path - path to the cacert file to be modified

Processing
----------

Use the os type and software type to find the cacert.pem file.  Add the bundle to that file. Currently supports windows, linux and mac servers.

Style
====

Use cookstyle for ruby linting.
Use foodcritic for cookbook checking.
