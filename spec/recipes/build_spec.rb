# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::build' do
  let(:ircd_user) { 'ircd-user' }
  let(:ircd_group) { 'ircd-group' }
  let(:ircd_source_dir) { '/home/ratbox/src' }
  let(:ircd_directory) { '/home/ratbox/ratbox' }
  let(:services_user) { 'services-user' }
  let(:services_group) { 'services-group' }
  let(:services_source_dir) { '/home/ratbox-services/src' }
  let(:services_directory) { '/home/ratbox-services/ratbox' }
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:ircd][:server][:user] = ircd_user
      node.set[:ircd][:server][:group] = ircd_group
      node.set[:ircd][:server][:sourcedir] = ircd_source_dir
      node.set[:ircd][:server][:directory] = ircd_directory
      node.set[:ircd][:services][:user] = services_user
      node.set[:ircd][:services][:group] = services_group
      node.set[:ircd][:services][:sourcedir] = services_source_dir
      node.set[:ircd][:services][:directory] = services_directory
    end.converge(described_recipe)
  end

  it 'should include build-essential' do
    expect(chef_run).to include_recipe 'build-essential'
  end

  it 'should install libssl-dev' do
    expect(chef_run).to install_package 'libssl-dev'
  end

  it 'should create the services install directory' do
    expect(chef_run).to create_directory(services_directory).with(
      owner: services_user,
      group: services_group,
      mode: 0750,
      recursive: true
    )
  end

  it 'should configure with services' do
    expect(chef_run).to run_bash('configure ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: "./configure --prefix=\"#{ircd_directory}\" --enable-services"
    )
  end

  it 'should build ratbox' do
    expect(chef_run).to run_bash('build ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: 'make'
    )
  end

  it 'should install ratbox' do
    expect(chef_run).to run_bash('install ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: 'make install'
    )
  end

  it 'should configure ratbox-services' do
    expect(chef_run).to run_bash('configure ratbox-services').with(
      user: services_user,
      group: services_group,
      cwd: services_source_dir,
      code: "./configure --prefix=\"#{services_directory}\""
    )
  end

  it 'should build ratbox-services' do
    expect(chef_run).to run_bash('build ratbox-services').with(
      user: services_user,
      group: services_group,
      cwd: services_source_dir,
      code: 'make'
    )
  end

  it 'should install ratbox-services' do
    expect(chef_run).to run_bash('install ratbox-services').with(
      user: services_user,
      group: services_group,
      cwd: services_source_dir,
      code: 'make install'
    )
  end
end
