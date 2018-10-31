require 'spec_helper'

describe 'vscode_es' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'minimal install' do
        let(:facts) { os_facts }

        it { is_expected.to compile }
        it do
          is_expected.to contain_file('/etc/systemd/system/puppet-languageserver.service').with({  
                                                                                                  'owner' => 'root',
                                                                                                  'group' => 'root',
                                                                                                  'mode'  => '0755',
                                                                                                })
        end
        
        it do
          is_expected.to contain_service('puppet-languageserver').with({
                                                                        'ensure' => 'running',
                                                                        'enable' => true,
                                                                        })
        end
      end
    end
  end
end
