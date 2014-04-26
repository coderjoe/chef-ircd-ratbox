# Encoding: utf-8
ircd_user = node[:ircd][:server][:user]
ircd_group = node[:ircd][:server][:group]
ircd_home = node[:ircd][:server][:directory]

services_user = node[:ircd][:services][:user]
services_group = node[:ircd][:services][:group]
services_home = node[:ircd][:services][:directory]

group ircd_group do
  system true
end

user ircd_user do
  gid ircd_group
  home ircd_home
  shell '/bin/false'
  comment 'The ircd-ratbox system user'
  system true
  supports(managed_home: true)
end

group services_group do
  system true
end

user services_user do
  gid services_group
  home services_home
  shell '/bin/false'
  comment 'The ratbox-services system user'
  system true
  supports(managed_home: true)
end
