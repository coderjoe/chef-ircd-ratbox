# Encoding: utf-8
name 'ircd-ratbox'
maintainer 'Joe Bauser'
maintainer_email 'coderjoe@coderjoe.net'
license 'All rights reserved'
description 'Installs ircd-ratbox and ratbox-services'
long_description 'Installs ircd-ratbox and ratbox-services'
version '0.1.0'

%w( build-essential ).each do |pkg|
  depends pkg
end
