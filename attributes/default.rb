# Encoding: utf-8
# rubocop:disable LineLength

# Defaults for install of ircd-ratbox
default[:ircd][:server][:user] = 'ratbox'
default[:ircd][:server][:group] = 'ratbox'
default[:ircd][:server][:directory] = '/home/ratbox'
default[:ircd][:server][:sourcedir] = '/home/ratbox/src'
default[:ircd][:server][:download] = 'http://www.ratbox.org/download/ircd-ratbox-3.0.8.tar.bz2'

# Defaults for install of ratbox-services
default[:ircd][:services][:user] = 'ratbox-services'
default[:ircd][:services][:group] = 'ratbox-services'
default[:ircd][:services][:directory] = '/home/ratbox-services'
default[:ircd][:services][:sourcedir] = '/home/ratbox-services/src'
default[:ircd][:services][:download] = 'http://www.ratbox.org/download/ratbox-services/ratbox-services-1.2.4.tgz'

# Configuration specific defaults
default[:ircd][:config][:ssl] = true
