# Encoding: utf-8
include_recipe 'build-essential'

ircd_user = node[:ircd][:server][:user]
ircd_group = node[:ircd][:server][:group]
ircd_directory = node[:ircd][:server][:directory]
ircd_source_dir = node[:ircd][:server][:sourcedir].chomp('/')
ircd_uri = node[:ircd][:server][:download]
ircd_filename = ircd_uri.split('/').last

# Build our user and group
group ircd_group do
  system true
end

user ircd_user do
  gid ircd_group
  home ircd_directory
  shell '/bin/false'
  comment 'The ircd-ratbox system user'
  system true
  supports(managed_home: true)
end

# Set up the install and source directories
[ircd_directory, ircd_source_dir].each do |dir|
  directory dir do
    owner ircd_user
    group ircd_group
    mode 0750
    recursive true
  end
end

# Download the source archive
remote_file("#{ircd_source_dir}/#{ircd_filename}") do
  source ircd_uri
  owner ircd_user
  group ircd_group
  mode 0640
  action :create_if_missing
end

# Extract it to the source directory
extract_cmd = "tar --strip-components=1 -xf #{ircd_filename}"
bash(extract_cmd) do
  user ircd_user
  group ircd_group
  cwd ircd_source_dir
  code extract_cmd
end

# Install SSL if requested
package 'libssl-dev' if node[:ircd][:config][:ssl]

# Configure, build, and install ratbox
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

directory("#{ircd_directory}/logs") do
  owner ircd_user
  group ircd_group
  mode 0750
end
