# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'should include ircd-ratbox::server' do
    expect(chef_run).to include_recipe 'ircd-ratbox::server'
  end

  it 'should include ircd-ratbox::services' do
    expect(chef_run).to include_recipe 'ircd-ratbox::services'
  end
end
