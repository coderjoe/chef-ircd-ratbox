# Encoding: utf-8

ircd_user = node[:ircd][:server][:user]
ircd_group = node[:ircd][:server][:group]
ircd_source_dir = node[:ircd][:server][:sourcedir].chomp('/')
ircd_uri = node[:ircd][:server][:download]
ircd_filename = ircd_uri.split('/').last

remote_file("#{ircd_source_dir}/#{ircd_filename}") do
  source ircd_uri
  owner ircd_user
  group ircd_group
  mode 0640
  action :create_if_missing
end

extract_cmd = "tar --strip-components=1 -xf #{ircd_filename}"
bash(extract_cmd) do
  user ircd_user
  group ircd_group
  cwd ircd_source_dir
  code extract_cmd
end

services_user = node[:ircd][:services][:user]
services_group = node[:ircd][:services][:group]
services_source_dir = node[:ircd][:services][:sourcedir].chomp('/')
services_uri = node[:ircd][:services][:download]
services_filename = services_uri.split('/').last

remote_file("#{services_source_dir}/#{services_filename}") do
  source services_uri
  owner services_user
  group services_group
  mode 0640
  action :create_if_missing
end

extract_cmd = "tar --strip-components=1 -xf #{services_filename}"
bash(extract_cmd) do
  user services_user
  group services_group
  cwd services_source_dir
  code extract_cmd
end
