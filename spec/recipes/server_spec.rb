# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::server' do
  def build_chef_run(opts = {})
    ChefSpec::Runner.new do |node|
      node.set[:ircd][:server][:user] = ircd_user
      node.set[:ircd][:server][:group] = ircd_group
      node.set[:ircd][:server][:sourcedir] = ircd_source_dir
      node.set[:ircd][:server][:directory] = ircd_directory
      node.set[:ircd][:server][:download] = ircd_uri

      node.set[:ircd][:config][:ssl] = opts.fetch(:ssl, true)
    end.converge(described_recipe)
  end

  let(:ircd_user) { 'ircd-user' }
  let(:ircd_group) { 'ircd-group' }
  let(:ircd_source_dir) { '/home/ratbox/src' }
  let(:ircd_directory) { '/home/ratbox' }
  let(:ircd_filename) { 'ircd-ratbox-9.7.8.tar.bz2' }
  let(:ircd_uri) { "http://fake.example.com/ircd/#{ircd_filename}" }

  let(:chef_run) { build_chef_run }
  let(:chef_no_ssl) { build_chef_run(ssl: false) }

  it 'should create the ircd directory' do
    expect(chef_run).to create_directory(ircd_directory).with(
      owner: ircd_user,
      group: ircd_group,
      mode: 0750,
      recursive: true
    )
  end

  it 'should create the ircd source directory' do
    expect(chef_run).to create_directory(ircd_source_dir).with(
      owner: ircd_user,
      group: ircd_group,
      mode: 0750,
      recursive: true
    )
  end

  it 'should create the ircd group' do
    expect(chef_run).to create_group(ircd_group).with(system: true)
  end

  it 'should create the ircd user' do
    expect(chef_run).to create_user(ircd_user).with(
      gid: ircd_group,
      home: ircd_directory,
      shell: '/bin/false',
      system: true,
      supports: { managed_home: true }
    )
  end

  it 'should download the ircd source code tarball' do
    expect(chef_run).to create_remote_file_if_missing(
      "#{ircd_source_dir}/#{ircd_filename}").with(
      source: ircd_uri,
      owner: ircd_user,
      group: ircd_group,
      mode: 0640
    )
  end

  it 'should extract the ircd source' do
    cmd = "tar --strip-components=1 -xf #{ircd_filename}"
    expect(chef_run).to run_bash(cmd).with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: cmd
    )
  end

  it 'should not extract if already extracted' do
    # rubocop:disable UselessAssignment
    exist = ::File.method(:exists?)
    # rubocop:enable UselessAssignment
    ::File.stub(:exist?) { |f| exist(f) }
    ::File.stub(:exist?).with("#{ircd_source_dir}/configure") do
      true
    end

    cmd = "tar --strip-components=1 -xf #{ircd_filename}"
    expect(chef_run).to_not run_bash(cmd)
  end

  it 'should include build-essential' do
    expect(chef_run).to include_recipe 'build-essential'
  end

  it 'should install libssl-dev if SSL is enabled' do
    expect(chef_run).to install_package 'libssl-dev'
  end

  it 'should not install libssl-dev if SSL is disabled' do
    expect(chef_no_ssl).to_not install_package 'libssl-dev'
  end

  it 'should configure with services' do
    expect(chef_run).to run_bash('configure ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: "./configure --prefix=\"#{ircd_directory}\" --enable-services"
    )
  end

  it 'should not configure if already configured' do
    # rubocop:disable UselessAssignment
    exist = ::File.method(:exists?)
    # rubocop:enable UselessAssignment
    ::File.stub(:exist?) { |f| exist(f) }
    ::File.stub(:exist?).with("#{ircd_source_dir}/Makefile") do
      true
    end

    expect(chef_run).to_not run_bash('configure ratbox')
  end

  it 'should build ratbox' do
    expect(chef_run).to run_bash('build ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: 'make'
    )
  end

  it 'should not build ratbox if already built' do
    # rubocop:disable UselessAssignment
    exist = ::File.method(:exists?)
    # rubocop:enable UselessAssignment
    ::File.stub(:exist?) { |f| exist(f) }
    ::File.stub(:exist?).with("#{ircd_source_dir}/ircd") do
      true
    end

    expect(chef_run).to_not run_bash('build ratbox')
  end

  it 'should install ratbox' do
    expect(chef_run).to run_bash('install ratbox').with(
      user: ircd_user,
      group: ircd_group,
      cwd: ircd_source_dir,
      code: 'make install'
    )
  end

  it 'should not install if already installed' do
    # rubocop:disable UselessAssignment
    exist = ::File.method(:exists?)
    # rubocop:enable UselessAssignment
    ::File.stub(:exist?) { |f| exist(f) }
    ::File.stub(:exist?).with("#{ircd_directory}/bin/ircd") do
      true
    end

    expect(chef_run).to_not run_bash('install ratbox')
  end

  it 'should add a logs directory to ratbox' do
    expect(chef_run).to create_directory("#{ircd_directory}/logs").with(
      owner: ircd_user,
      group: ircd_group,
      mode: 0750
    )
  end
end
