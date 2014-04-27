# Encoding: utf-8
include_recipe 'build-essential'

services_user = node[:ircd][:services][:user]
services_group = node[:ircd][:services][:group]
services_directory = node[:ircd][:services][:directory]
services_source_dir = node[:ircd][:services][:sourcedir]
services_uri = node[:ircd][:services][:download]
services_filename = services_uri.split('/').last

group services_group do
  system true
end

user services_user do
  gid services_group
  home services_directory
  shell '/bin/false'
  comment 'The ratbox-services system user'
  system true
  supports(managed_home: true)
end

[services_directory, services_source_dir].each do |dir|
  directory dir do
    owner services_user
    group services_group
    mode 0750
    recursive true
  end
end

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

package 'libssl-dev'

bash('configure ratbox-services') do
  user services_user
  group services_group
  cwd services_source_dir
  code "./configure --prefix=\"#{services_directory}\""
end

bash('build ratbox-services') do
  user services_user
  group services_group
  cwd services_source_dir
  code 'make'
end

bash('install ratbox-services') do
  user services_user
  group services_group
  cwd services_source_dir
  code 'make install'
end
