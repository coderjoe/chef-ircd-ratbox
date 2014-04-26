# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::download' do
  let(:ircd_source_dir) { '/usr/local/ircd/ratbox/src' }
  let(:ircd_filename) { 'ircd-ratbox-9.7.8.tar.bz2' }
  let(:ircd_uri) { "http://fake.example.com/ircd/#{ircd_filename}" }
  let(:ircd_user) { 'ircd-usertime' }
  let(:ircd_group) { 'ircd-groupy' }

  let(:services_source_dir) { '/usr/local/ircd/ratbox-services/src' }
  let(:services_filename) { 'ratbox-services-3.1.4.tgz' }
  let(:services_uri) { "http://example.com/services/#{services_filename}" }
  let(:services_user) { 'services-usertime' }
  let(:services_group) { 'services-groupy' }

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:ircd][:server][:user] = ircd_user
      node.set[:ircd][:server][:group] = ircd_group
      node.set[:ircd][:server][:sourcedir] = ircd_source_dir
      node.set[:ircd][:server][:download] = ircd_uri

      node.set[:ircd][:services][:user] = services_user
      node.set[:ircd][:services][:group] = services_group
      node.set[:ircd][:services][:sourcedir] = services_source_dir
      node.set[:ircd][:services][:download] = services_uri
    end.converge(described_recipe)
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

  it 'should download the services source code tarball' do
    expect(chef_run).to create_remote_file_if_missing(
      "#{services_source_dir}/#{services_filename}").with(
      source: "#{services_uri}",
      owner: services_user,
      group: services_group,
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

  it 'should extract the services source' do
    cmd = "tar --strip-components=1 -xf #{services_filename}"
    expect(chef_run).to run_bash(cmd).with(
      user: services_user,
      group: services_group,
      cwd: services_source_dir,
      code: cmd
    )
  end
end
