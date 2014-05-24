# Encoding: utf-8
require 'spec_helper'

describe 'ircd-ratbox::server' do
  let(:user) { 'ratbox' }
  let(:group) { 'ratbox' }

  describe group('ratbox') do
    it { should exist }
  end

  describe user('ratbox') do
    it { should exist }
    it { should belong_to_group group }
    it { should have_home_directory '/home/ratbox' }
    it { should have_login_shell '/bin/false' }
  end

  ['/home/ratbox', '/home/ratbox/src', '/home/ratbox/logs'].each do |dir|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 750 }
    end
  end

  %w(bin etc help include lib libexec modules).each do |dir|
    describe file("/home/ratbox/#{dir}") do
      it { should be_directory }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 755 }
    end
  end

  %w(bantool ircd ratbox-mkpasswd ratbox-sqlite3).each do |f|
    describe file("/home/ratbox/bin/#{f}") do
      it { should be_file }
      it { should be_owned_by user }
      it { should be_grouped_into group }
      it { should be_mode 755 }
    end
  end

  %w(example.conf example.efnet.conf ircd.motd).each do |f|
    describe file("/home/ratbox/etc/#{f}") do
      it { should be_file }
      it { should be_owned_by user }
      it { should be_grouped_into group }

      it { should be_mode 644 }
    end
  end

end
