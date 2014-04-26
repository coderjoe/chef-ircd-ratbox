# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::source' do
  let(:ircd_user) { 'ircd-user' }
  let(:ircd_group) { 'ircd-group' }
  let(:services_user) { 'services-user' }
  let(:services_group) { 'services-group' }
  let(:ircd_version) { '3.0.8' }
  let(:ircd_source_dir) { '/usr/local/ircd/ratbox/src' }
  let(:services_version) { '1.2.3' }
  let(:services_source_dir) { '/usr/local/ircd/ratbox-services/src' }
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:ircd][:server][:user] = ircd_user
      node.set[:ircd][:server][:group] = ircd_group
      node.set[:ircd][:services][:user] = services_user
      node.set[:ircd][:services][:group] = services_group

      node.set[:ircd][:server][:sourcedir] = ircd_source_dir
      node.set[:ircd][:services][:sourcedir] = services_source_dir
    end.converge(described_recipe)
  end

  it 'should create the ircd source directory' do
    expect(chef_run).to create_directory(ircd_source_dir).with(
      owner: ircd_user,
      group: ircd_group,
      mode: 0750,
      recursive: true
    )
  end

  it 'should create the services source directory' do
    expect(chef_run).to create_directory(services_source_dir).with(
      owner: services_user,
      group: services_group,
      mode: 0750,
      recursive: true
    )
  end

  it 'should include ircd-ratbox::users' do
    expect(chef_run).to include_recipe 'ircd-ratbox::users'
  end

  it 'should include ircd-ratbox::download' do
    expect(chef_run).to include_recipe 'ircd-ratbox::download'
  end

  it 'should include ircd-ratbox::build' do
    expect(chef_run).to include_recipe 'ircd-ratbox::build'
  end
end
