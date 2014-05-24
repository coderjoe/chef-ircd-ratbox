# Encoding: utf-8
require 'spec_helper'

def build_chef_run(opts = {})
  ChefSpec::Runner.new do |node|
    node.set[:ircd][:services][:user] = services_user
    node.set[:ircd][:services][:group] = services_group
    node.set[:ircd][:services][:sourcedir] = services_source_dir
    node.set[:ircd][:services][:directory] = services_directory
    node.set[:ircd][:services][:download] = services_uri

    node.set[:ircd][:config][:ssl] = opts.fetch(:ssl, true)
  end.converge(described_recipe)
end

describe 'ircd-ratbox::services' do
  let(:services_user) { 'services-user' }
  let(:services_group) { 'services-group' }
  let(:services_source_dir) { '/home/services/src' }
  let(:services_directory) { '/home/services' }
  let(:services_filename) { 'ratbox-servuces-9.7.8.tar.bz2' }
  let(:services_uri) do
    "http://fake.example.com/ratbox-svc/#{services_filename}"
  end

  let(:chef_run) { build_chef_run }
  let(:chef_no_ssl) { build_chef_run(ssl: false) }

  it 'should create the services group' do
    expect(chef_run).to create_group(services_group).with(system: true)
  end

  it 'should create the services user' do
    expect(chef_run).to create_user(services_user).with(
      gid: services_group,
      home: services_directory,
      shell: '/bin/false',
      system: true,
      supports: { managed_home: true }
    )
  end

  it 'should create the services directory' do
    expect(chef_run).to create_directory(services_directory).with(
      owner: services_user,
      group: services_group,
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

  it 'should download the services source code tarball' do
    expect(chef_run).to create_remote_file_if_missing(
      "#{services_source_dir}/#{services_filename}").with(
      source: services_uri,
      owner: services_user,
      group: services_group,
      mode: 0640
    )
  end

  it 'should extract the services source' do
    cmd = "tar --strip-components=1 -xf #{services_filename}"
    expect(chef_run).to run_bash(cmd).with(
      user: services_user,
      group: services_group,
      cwd: services_source_dir,
      code: cmd
    )
  end

  it 'should include build-essential' do
    expect(chef_run).to include_recipe 'build-essential'
  end

  it 'should install the libssl-dev if SSL is enabled' do
    expect(chef_run).to install_package 'libssl-dev'
  end

  it 'should not install the libssl-dev library if SSL is disabled' do
    expect(chef_no_ssl).to_not install_package 'libssl-dev'
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
