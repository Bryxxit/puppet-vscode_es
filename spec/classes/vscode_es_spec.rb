require 'spec_helper'

describe 'vscode_es' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context "minimal install" do
        let(:facts) { os_facts }
  
        it { is_expected.to compile }
        it { should contain_file('/etc/systemd/system/puppet-languageserver.service').with(
          :owner => 'root',
          :group => 'root',
          :mode  => '0755',
        )}
        it { should contain_service('puppet-languageserver').with(
          :ensure => 'running',
          :enable => true,
        )}
      end
    end
  end
end
