require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'varnish' do

  let(:title) { 'varnish' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42',
                  :concat_basedir => '/var/lib/puppet/concat' } }

  describe 'Test standard installation' do
    it { should contain_package('varnish').with_ensure('present') }
    it { should contain_service('varnish').with_ensure('running') }
    it { should contain_service('varnish').with_enable('true') }
    it { should contain_file('varnish.conf').with_ensure('present') }
    it { should contain_file('varnish.secret').with_ensure('present') }
    it { should contain_file('varnish.vcl').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('varnish').with_ensure('1.0.42') }
  end

  describe 'Test varnish configuration on CentOS' do
    let(:facts) { { :operatingsystem => 'CentOS', } }
    let(:params) do
      {
        :vcl_template         => 'varnish/default.vcl.erb',
        :vcl_file             => '/etc/varnish/centos.vcl',
        :template             => 'varnish/varnish.erb',
        :debian_start         => true,
        :reload_vcl           => '1',
        :vcl_conf             => 'centosvcl_conf',
        :vcl_file             => 'somevcl_file',
        :port                 => '4242',
        :admin_listen_address => '10.43.10.43',
        :admin_listen_port    => '4343',
      }
    end
    let (:expected) do
"# This file is managed by Puppet. DO NOT EDIT.

INSTANCE=default

NFILES=131072
MEMLOCK=82000
NPROCS=unlimited

RELOAD_VCL=1

VARNISH_VCL_CONF=centosvcl_conf
VARNISH_LISTEN_PORT=4242
VARNISH_ADMIN_LISTEN_ADDRESS=10.43.10.43
VARNISH_ADMIN_LISTEN_PORT=4343
VARNISH_MIN_THREADS=1
VARNISH_MAX_THREADS=1000
VARNISH_THREAD_TIMEOUT=120
VARNISH_SECRET_FILE=/etc/varnish/secret
VARNISH_TTL=120

VARNISH_STORAGE_SIZE=1G
VARNISH_STORAGE_FILE=/var/lib/varnish/$INSTANCE/varnish_storage.bin

VARNISH_STORAGE=\"file,${VARNISH_STORAGE_FILE},${VARNISH_STORAGE_SIZE}\"

DAEMON_OPTS=\" \\
    -a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \\
    -f ${VARNISH_VCL_CONF} \\
    -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \\
    -t ${VARNISH_TTL} \\
    -w ${VARNISH_MIN_THREADS},${VARNISH_MAX_THREADS},${VARNISH_THREAD_TIMEOUT} \\
    -S ${VARNISH_SECRET_FILE} \\
    -s ${VARNISH_STORAGE} \\
\"
"
    end
    it { should contain_file('varnish.conf').with_content(expected) }
  end


  describe 'Test varnish configuration on Debian' do
    let(:facts) { { :operatingsystem => 'Debian', } }
    let(:params) do
      {
        :vcl_template         => 'varnish/default.vcl.erb',
        :vcl_file             => '/etc/varnish/default.vcl',
        :template             => 'varnish/varnish.erb',
        :backendhost          => 'somebackendhost',
        :backendport          => 'somebackendport',
        :debian_start         => true,
        :instance             => 'someinstance',
        :nfiles               => '1234',
        :memlock              => '5678',
        :nprocs               => '9',
        :reload_vcl           => '1',
        :vcl_conf             => 'somevcl_conf',
        :vcl_file             => 'somevcl_file',
        :listen_address       => '10.42.10.42',
        :port                 => '4242',
        :admin_listen_address => '10.43.10.43',
        :admin_listen_port    => '4343',
        :min_threads          => '5',
        :max_threads          => '15',
        :thread_timeout       => '1155',
        :secret_file          => 'somesecret_file',
        :ttl                  => '333',
        :storage_size         => '4G',
        :storage_file         => 'somestorage_file',
      }
    end
    let (:config_expected) do
"# This file is managed by Puppet. DO NOT EDIT.
START=yes

INSTANCE=someinstance

NFILES=1234
MEMLOCK=5678
NPROCS=9

RELOAD_VCL=1

VARNISH_VCL_CONF=somevcl_conf
VARNISH_LISTEN_ADDRESS=10.42.10.42
VARNISH_LISTEN_PORT=4242
VARNISH_ADMIN_LISTEN_ADDRESS=10.43.10.43
VARNISH_ADMIN_LISTEN_PORT=4343
VARNISH_MIN_THREADS=5
VARNISH_MAX_THREADS=15
VARNISH_THREAD_TIMEOUT=1155
VARNISH_SECRET_FILE=somesecret_file
VARNISH_TTL=333

VARNISH_STORAGE_SIZE=4G
VARNISH_STORAGE_FILE=somestorage_file

VARNISH_STORAGE=\"file,${VARNISH_STORAGE_FILE},${VARNISH_STORAGE_SIZE}\"

DAEMON_OPTS=\" \\
    -a ${VARNISH_LISTEN_ADDRESS}:${VARNISH_LISTEN_PORT} \\
    -f ${VARNISH_VCL_CONF} \\
    -T ${VARNISH_ADMIN_LISTEN_ADDRESS}:${VARNISH_ADMIN_LISTEN_PORT} \\
    -t ${VARNISH_TTL} \\
    -w ${VARNISH_MIN_THREADS},${VARNISH_MAX_THREADS},${VARNISH_THREAD_TIMEOUT} \\
    -S ${VARNISH_SECRET_FILE} \\
    -s ${VARNISH_STORAGE} \\
\"
"
    end
    let (:vcl_expected) do
"# This file is managed by Puppet. DO NOT EDIT.
backend default {
  .host = \"somebackendhost\";
  .port = \"somebackendport\";
}
"
    end
    it { should contain_file('varnish.conf').with_content(config_expected) }
    it { should contain_file('varnish.vcl').with_content(vcl_expected) }
  end

  describe 'Test standard installation with monitoring and firewalling' do
    let(:params) { {:monitor => true , :firewall => true, :port => '42', :protocol => 'tcp' } }
    it { should contain_package('varnish').with_ensure('present') }
    it { should contain_service('varnish').with_ensure('running') }
    it { should contain_service('varnish').with_enable('true') }
    it { should contain_file('varnish.conf').with_ensure('present') }
    it { should contain_monitor__process('varnish_process').with_enable('true') }
    it { should contain_firewall('varnish_tcp_42').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it 'should remove Package[varnish]' do should contain_package('varnish').with_ensure('absent') end
    it 'should stop Service[varnish]' do should contain_service('varnish').with_ensure('stopped') end
    it 'should not enable at boot Service[varnish]' do should contain_service('varnish').with_enable('false') end
    it 'should remove varnish configuration file' do should contain_file('varnish.conf').with_ensure('absent') end
    it { should contain_monitor__process('varnish_process').with_enable('false') }
    it { should contain_firewall('varnish_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('varnish').with_ensure('present') }
    it 'should stop Service[varnish]' do should contain_service('varnish').with_ensure('stopped') end
    it 'should not enable at boot Service[varnish]' do should contain_service('varnish').with_enable('false') end
    it { should contain_file('varnish.conf').with_ensure('present') }
    it { should contain_monitor__process('varnish_process').with_enable('false') }
    it { should contain_firewall('varnish_tcp_42').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('varnish').with_ensure('present') }
    it { should_not contain_service('varnish').with_ensure('present') }
    it { should_not contain_service('varnish').with_ensure('absent') }
    it 'should not enable at boot Service[varnish]' do should contain_service('varnish').with_enable('false') end
    it { should contain_file('varnish.conf').with_ensure('present') }
    it { should contain_monitor__process('varnish_process').with_enable('false') }
    it { should contain_firewall('varnish_tcp_42').with_enable('true') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, :monitor => true , :firewall => true, :port => '42', :protocol => 'tcp'} }
    it { should contain_package('varnish').with_noop('true') }
    it { should contain_service('varnish').with_noop('true') }
    it { should contain_file('varnish.conf').with_noop('true') }
    it { should contain_monitor__process('varnish_process').with_noop('true') }
    it { should contain_monitor__process('varnish_process').with_noop('true') }
    it { should contain_monitor__port('varnish_tcp_42').with_noop('true') }
    it { should contain_firewall('varnish_tcp_42').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "varnish/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'varnish.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'varnish.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/varnish/spec"} }
    it { should contain_file('varnish.conf').with_source('puppet:///modules/varnish/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/varnish/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('varnish.dir').with_source('puppet:///modules/varnish/dir/spec') }
    it { should contain_file('varnish.dir').with_purge('true') }
    it { should contain_file('varnish.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "varnish::spec" } }
    it { should contain_file('varnish.conf').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) { {:service_autorestart => "no" } }
    it 'should not automatically restart the service, when service_autorestart => false' do
      content = catalogue.resource('file', 'varnish.conf').send(:parameters)[:notify]
      content.should be_nil
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('varnish').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('varnish_process').with_tool('puppi') }
  end

  describe 'Test Firewall Tools Integration' do
    let(:params) { {:firewall => true, :firewall_tool => "iptables" , :protocol => "tcp" , :port => "42" } }
    it { should contain_firewall('varnish_tcp_42').with_tool('iptables') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi" , :firewall => "yes" , :firewall_tool => "iptables" , :puppi => "yes" , :port => "42" , :protocol => 'tcp' } }
    it { should contain_monitor__process('varnish_process').with_tool('puppi') }
    it { should contain_firewall('varnish_tcp_42').with_tool('iptables') }
    it { should contain_puppi__ze('varnish').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('varnish_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :varnish_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour module specific vars' do should contain_monitor__process('varnish_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :varnish_monitor => true , :ipaddress => '10.42.42.42' } }
    let(:params) { { :port => '42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('varnish_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true , :firewall => true, :port => '42' } }
    it 'should honour passed params over global vars' do should contain_monitor__process('varnish_process').with_enable('true') end
  end

end
