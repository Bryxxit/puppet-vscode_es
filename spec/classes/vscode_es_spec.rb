require 'spec_helper'

describe 'vscode_es' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'minimal install' do
        let(:facts) { os_facts }

        it { is_expected.to compile }
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service').with(
            'owner' => 'root',
            'group' => 'root',
            'mode'  => '0755',
          )

          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --timeout=10$})

          is_expected.to contain_service('puppet-languageserver').with(
            'ensure' => 'running',
            'enable' => true,
          )
        end
      end

      context 'minimal install failures' do
        let(:params) { { 'debug' => true } }

        it { is_expected.to compile.and_raise_error(%r{If debug == true}) }
      end

      context 'with port => 9654' do
        let(:params) { { 'port' => 9654 } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* -p 9654$})
        end
      end

      context 'with ipaddr => 0.0.0.0' do
        let(:params) { { 'ipaddr' => '0.0.0.0' } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* -i 0.0.0.0$})
        end
      end

      context 'with nostop => true' do
        let(:params) { { 'nostop' => true } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --no-stop$})
        end
      end

      context 'with debug => true' do
        let(:params) { { 'debug' => true, 'debugpath' => '/var/log/puppet/puppet-languageserver' } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --debug=/var/log/puppet/puppet-languageserver/debug.log$})
        end
      end

      context 'with slowstart => true' do
        let(:params) { { 'slowstart' => true } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --slow-start$})
        end
      end

      context 'with filecache => true' do
        let(:params) { { 'filecache' => true } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --enable-file-cache$})
        end
      end

      context 'with workspace => /opt/puppetlabs/code' do
        let(:params) { { 'workspace' => '/opt/puppetlabs/code' } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* --local-workspace=/opt/puppetlabs/code$})
        end
      end

      context 'with standard set of params' do
        let(:params) { { 'port' => 9654, 'ipaddr' => '0.0.0.0', 'nostop' => true } }

        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service') \
            .with_content(%r{^ExecStart=.* -p 9654 -i 0.0.0.0 --no-stop$})
        end
      end
    end
  end
end
