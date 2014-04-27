# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::services' do
  let(:user) { 'ratbox-services' }
  let(:group) { 'ratbox-services' }

  describe group('ratbox-services') do
    it { should exist }
  end

  describe user('ratbox-services') do
    it { should exist }
    it { should belong_to_group group }
    it { should have_home_directory '/home/ratbox-services' }
    it { should have_login_shell '/bin/false' }
  end

  describe file('/home/ratbox-services') do
    it { should be_directory }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 750 }
  end

  # 750 directories
  %w(etc sbin src).each do |dir|
    describe file("/home/ratbox-services/#{dir}") do
      it { should be_directory }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 750 }
    end
  end

  # 755 directories
  %w(bin include lib share var).each do |dir|
    describe file("/home/ratbox-services/#{dir}") do
      it { should be_directory }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 755 }
    end
  end

  # 750 files
  %w(bin/dbupgrade.pl bin/ircd-shortcut.pl sbin/ratbox-services).each do |f|
    describe file("/home/ratbox-services/#{f}") do
      it { should be_file }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 750 }
    end
  end

  describe file('/home/ratbox-services/bin/sqlite3') do
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 755 }
  end

  describe file('/home/ratbox-services/etc/example.conf') do
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }

    it { should be_mode 640 }
  end
end
