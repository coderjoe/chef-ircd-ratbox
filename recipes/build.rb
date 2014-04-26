# Encoding: utf-8
include_recipe 'build-essential'

package 'libssl-dev'

ircd_user = node[:ircd][:server][:user]
ircd_group = node[:ircd][:server][:group]
ircd_source_dir = node[:ircd][:server][:sourcedir]
ircd_directory = node[:ircd][:server][:directory]

directory(ircd_directory) do
  owner ircd_user
  group ircd_group
  mode 0750
  recursive true
end

bash('configure ratbox') do
  user ircd_user
  group ircd_group
  cwd ircd_source_dir
  code "./configure --prefix=\"#{ircd_directory}\" --enable-services"
end

bash('build ratbox') do
  user ircd_user
  group ircd_group
  cwd ircd_source_dir
  code 'make'
end

bash('install ratbox') do
  user ircd_user
  group ircd_group
  cwd ircd_source_dir
  code 'make install'
end

services_user = node[:ircd][:services][:user]
services_group = node[:ircd][:services][:group]
services_source_dir = node[:ircd][:services][:sourcedir]
services_directory = node[:ircd][:services][:directory]

directory(services_directory) do
  owner services_user
  group services_group
  mode 0750
  recursive true
end

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
