# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::users' do
  let(:ircd_user) { 'ircd-user' }
  let(:ircd_group) { 'ircd-group' }
  let(:ircd_home) { '/usr/local/ircd/ratbox' }

  let(:services_user) { 'services-user' }
  let(:services_group) { 'services-group' }
  let(:services_home) { '/usr/local/ircd/ratbox-services' }

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:ircd][:server][:user] = ircd_user
      node.set[:ircd][:server][:group] = ircd_group
      node.set[:ircd][:server][:directory] = ircd_home
      node.set[:ircd][:services][:user] = services_user
      node.set[:ircd][:services][:group] = services_group
      node.set[:ircd][:services][:directory] = services_home
    end.converge(described_recipe)
  end

  it 'should create the ircd group' do
    expect(chef_run).to create_group(ircd_group).with(system: true)
  end

  it 'should create the ircd user' do
    expect(chef_run).to create_user(ircd_user).with(
      gid: ircd_group,
      home: ircd_home,
      shell: '/bin/false',
      system: true,
      supports: { managed_home: true }
    )
  end

  it 'should create the services group' do
    expect(chef_run).to create_group(services_group).with(system: true)
  end

  it 'should create the services user' do
    expect(chef_run).to create_user(services_user).with(
      gid: services_group,
      home: services_home,
      shell: '/bin/false',
      system: true,
      supports: { managed_home: true }
    )
  end
end
