# Encoding: utf-8
include_recipe 'ircd-ratbox::users'

directory node[:ircd][:server][:sourcedir] do
  owner node[:ircd][:server][:user]
  group node[:ircd][:server][:group]
  mode 0750
  recursive true
end

directory node[:ircd][:services][:sourcedir] do
  owner node[:ircd][:services][:user]
  group node[:ircd][:services][:group]
  mode 0750
  recursive true
end

include_recipe 'ircd-ratbox::download'
include_recipe 'ircd-ratbox::build'
