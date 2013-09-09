## = Class: varnish
#
# This is the main varnish class
#
#
# == Parameters
#
# If you use a template to config varnish, the following defaults will be used.
# They are pretty much the same CentOS and Debian use as their defaults.
# Note that if you don't specify a template file, no config file will be
# handled by this module and those files the distro package has will be left
# untouched.
#
#
# [*backendhost*]
#   Backend fqdn or IP for the default VCL
#   Default: localhost
#
# [*backendport*]
#   Backend port for the VCL
#   Default: 8008
#
# [*debian_start*]
#   Debian adds this variable to the default config to see if we start or not
#   varnish.
#   It will not be used if @operatingsystem != /(?i:Debian|Ubuntu|Mint)/
#   Default: true.
#
# [*instance*]
#   Instance name.
#   Default: "default"
#
# [*nfiles*]
#   Maximum number of open files (for ulimit -n)
#   Default: 131072
#
# [*memlock*]
#   Locked shared memory (for ulimit -l)
#   Default log size is 82MB + header
#
# [*nprocs*]
#   Maximum number of threads (for ulimit -u
#   Default: "unlimited"
#
# [*reload_vcl*]
#   Set this to 1 to make init script reload try to switch vcl without restart.
#   To make this work, you need to set the following variables
#   explicit: [*vcl_conf*], [*admin_listen_address*],
#   [*admin_listen_port*], [*secret_file*]
#   Default: 1
#
# [*vcl_conf*]
#   Main configuration file. You probably want to change it :)
#   Default: /etc/varnish/default.vcl
#
# [*listen_address*]
#   Default address and port to bind to
#   Blank address means all IPv4 and IPv6 interfaces, otherwise specify
#   a host name, an IPv4 dotted quad, or an IPv6 address in brackets.
#   Default: ''
#
# [*port*]
#   Default port to bind to. You probably want to change it to 80 :)
#   Default: 6081
#
# [*admin_listen_address*]
# [*admin_listen_port*]
#   Telnet admin interface listen address and port
#   Default: 127.0.0.1:6082
#
# [*min_threads*]
#   The minimum number of worker threads to start
#   Default: 1
#
# [*max_threads*]
#   The Maximum number of worker threads to start
#   Default: 1000
#
# [*thread_timeout*]
#   Idle timeout for worker threads, in seconds
#   Default: 120
#
# [*secret*]
#   The password user by varnish admin.
#   If blank, it's untouched and left to whatever the distro package sets.
#   If 'auto' a random password is generated
#
# [*secret_file*]
#   Shared secret file for admin interface
#   Default: /etc/varnish/secret
#
# [*ttl*]
#   Default TTL used when the backend does not specify on, in seconds
#   Default: 120
#
# [*storage_size*]
#   Cache file size: in bytes, optionally using k / M / G / T suffix,
#   or in percentage of available disk space using the % suffix.
#   Default: 1G
#
# [*storage_file*]
#   Cache file location
#   Default: /var/lib/varnish/$INSTANCE/varnish_storage.bin
#
# [*vcl_template*]
#   Template file to setup the backend.
#   Default: empty.
#
# [*vcl_source*]
#   Source file to setup the backend.
#   Default: empty
#
# [*vcl_file*]
#   VCL file name.
#   Default: empty
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, varnish class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $varnish_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, varnish main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $varnish_source
#
# [*source_dir*]
#   If defined, the whole varnish configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $varnish_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $varnish_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, varnish main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $varnish_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $varnish_options
#
# [*service_autorestart*]
#   Automatically restarts the varnish service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $varnish_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $varnish_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $varnish_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $varnish_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for varnish checks
#   Can be defined also by the (top scope) variables $varnish_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $varnish_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $varnish_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $varnish_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $varnish_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for varnish port(s)
#   Can be defined also by the (top scope) variables $varnish_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling varnish. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $varnish_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $varnish_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $varnish_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $varnish_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in varnish::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of varnish package
#
# [*service*]
#   The name of varnish service
#
# [*service_status*]
#   If the varnish service init script supports status argument
#
# [*service_restart*]
#   Command to execute to restart the service.
#   Default: empty. Leave puppet manage the restart cycle
#
# [*process*]
#   The name of varnish process
#
# [*process_args*]
#   The name of varnish arguments. Used by puppi and monitor.
#   Used only in case the varnish process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user varnish runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $varnish_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $varnish_protocol
#
#
# See README for usage patterns.
#
class varnish (
  $my_class             = params_lookup( 'my_class' ),
  $backendhost          = params_lookup( 'backendhost' ),
  $backendport          = params_lookup( 'backendport' ),
  $debian_start         = params_lookup( 'debian_start' ),
  $instance             = params_lookup( 'instance' ),
  $nfiles               = params_lookup( 'nfiles' ),
  $memlock              = params_lookup( 'memlock' ),
  $nprocs               = params_lookup( 'nprocs' ),
  $reload_vcl           = params_lookup( 'reload_vcl' ),
  $vcl_conf             = params_lookup( 'vcl_conf' ),
  $vcl_template         = params_lookup( 'vcl_template' ),
  $vcl_source           = params_lookup( 'vcl_source' ),
  $vcl_file             = params_lookup( 'vcl_file' ),
  $listen_address       = params_lookup( 'listen_address' ),
  $port                 = params_lookup( 'port' ),
  $admin_listen_address = params_lookup( 'admin_listen_address' ),
  $admin_listen_port    = params_lookup( 'admin_listen_port' ),
  $min_threads          = params_lookup( 'min_threads' ),
  $max_threads          = params_lookup( 'max_threads' ),
  $thread_timeout       = params_lookup( 'thread_timeout' ),
  $secret               = params_lookup( 'secret' ),
  $secret_file          = params_lookup( 'secret_file' ),
  $ttl                  = params_lookup( 'ttl' ),
  $storage_size         = params_lookup( 'storage_size' ),
  $storage_file         = params_lookup( 'storage_file' ),
  $source               = params_lookup( 'source' ),
  $source_dir           = params_lookup( 'source_dir' ),
  $source_dir_purge     = params_lookup( 'source_dir_purge' ),
  $template             = params_lookup( 'template' ),
  $service_autorestart  = params_lookup( 'service_autorestart' , 'global' ),
  $service_restart      = params_lookup( 'service_restart' ),
  $options              = params_lookup( 'options' ),
  $version              = params_lookup( 'version' ),
  $absent               = params_lookup( 'absent' ),
  $disable              = params_lookup( 'disable' ),
  $disableboot          = params_lookup( 'disableboot' ),
  $monitor              = params_lookup( 'monitor' , 'global' ),
  $monitor_tool         = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target       = params_lookup( 'monitor_target' , 'global' ),
  $puppi                = params_lookup( 'puppi' , 'global' ),
  $puppi_helper         = params_lookup( 'puppi_helper' , 'global' ),
  $firewall             = params_lookup( 'firewall' , 'global' ),
  $firewall_tool        = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src         = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst         = params_lookup( 'firewall_dst' , 'global' ),
  $debug                = params_lookup( 'debug' , 'global' ),
  $audit_only           = params_lookup( 'audit_only' , 'global' ),
  $noops                = params_lookup( 'noops' ),
  $package              = params_lookup( 'package' ),
  $service              = params_lookup( 'service' ),
  $service_status       = params_lookup( 'service_status' ),
  $process              = params_lookup( 'process' ),
  $process_args         = params_lookup( 'process_args' ),
  $process_user         = params_lookup( 'process_user' ),
  $config_dir           = params_lookup( 'config_dir' ),
  $config_file          = params_lookup( 'config_file' ),
  $config_file_mode     = params_lookup( 'config_file_mode' ),
  $config_file_owner    = params_lookup( 'config_file_owner' ),
  $config_file_group    = params_lookup( 'config_file_group' ),
  $config_file_init     = params_lookup( 'config_file_init' ),
  $pid_file             = params_lookup( 'pid_file' ),
  $data_dir             = params_lookup( 'data_dir' ),
  $log_dir              = params_lookup( 'log_dir' ),
  $log_file             = params_lookup( 'log_file' ),
  $port                 = params_lookup( 'port' ),
  $protocol             = params_lookup( 'protocol' )
  ) inherits varnish::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  ### Varnish secret setup
  $real_varnish_secret = $varnish::secret ? {
    ''      => '',
    'auto'  => fqdn_rand(100000000000),
    default => $varnish::secret,
  }

  $bool_debian_start = $::operatingsystem ? {
     /(?i:Debian|Ubuntu|Mint)/ => any2bool($debian_start) ? {
       true  => 'yes',
       false => 'no',
     },
     default                   => false,
  }

  $manage_package = $varnish::bool_absent ? {
    true  => 'absent',
    false => $varnish::version,
  }

  $manage_service_enable = $varnish::bool_disableboot ? {
    true    => false,
    default => $varnish::bool_disable ? {
      true    => false,
      default => $varnish::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_restart = $service_restart ? {
    ''      => undef,
    default => $service_restart,
  }

  $manage_service_ensure = $varnish::bool_disable ? {
    true    => 'stopped',
    default =>  $varnish::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $varnish::bool_service_autorestart ? {
    true    => Service[varnish],
    false   => undef,
  }

  $manage_file = $varnish::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $varnish::bool_absent == true
  or $varnish::bool_disable == true
  or $varnish::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $varnish::bool_absent == true
  or $varnish::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $varnish::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $varnish::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $varnish::source ? {
    ''        => undef,
    default   => $varnish::source,
  }

  $manage_file_content = $varnish::template ? {
    ''        => undef,
    default   => template($varnish::template),
  }

  $manage_vcl_file_source = $varnish::vcl_source ? {
    ''        => undef,
    default   => $varnish::vcl_source,
  }

  $manage_vcl_file_content = $varnish::vcl_template ? {
    ''        => undef,
    default   => template($varnish::vcl_template),
  }

  ### Managed resources
  package { $varnish::package:
    ensure  => $varnish::manage_package,
    noop    => $varnish::noops,
  }

  service { 'varnish':
    ensure     => $varnish::manage_service_ensure,
    name       => $varnish::service,
    enable     => $varnish::manage_service_enable,
    hasstatus  => $varnish::service_status,
    pattern    => $varnish::process,
    restart    => $varnish::manage_service_restart,
    require    => Package[$varnish::package],
    noop       => $varnish::noops,
  }

  file { 'varnish.conf':
    ensure  => $varnish::manage_file,
    path    => $varnish::config_file,
    mode    => $varnish::config_file_mode,
    owner   => $varnish::config_file_owner,
    group   => $varnish::config_file_group,
    require => Package[$varnish::package],
    notify  => $varnish::manage_service_autorestart,
    source  => $varnish::manage_file_source,
    content => $varnish::manage_file_content,
    replace => $varnish::manage_file_replace,
    audit   => $varnish::manage_audit,
    noop    => $varnish::noops,
  }

  file { 'varnish.secret':
    ensure  => $varnish::manage_file,
    path    => $varnish::secret_file,
    mode    => $varnish::config_file_mode,
    owner   => $varnish::config_file_owner,
    group   => $varnish::config_file_group,
    require => Package[$varnish::package],
    notify  => $varnish::manage_service_autorestart,
    content => "${varnish::real_varnish_secret}\n",
    replace => $varnish::manage_file_replace,
    audit   => $varnish::manage_audit,
    noop    => $varnish::noops,
  }

  file { 'varnish.vcl':
    ensure  => $varnish::manage_file,
    path    => $varnish::vcl_file,
    mode    => $varnish::config_file_mode,
    owner   => $varnish::config_file_owner,
    group   => $varnish::config_file_group,
    require => Package[$varnish::package],
    notify  => $varnish::manage_service_autorestart,
    source  => $varnish::manage_vcl_file_source,
    content => $varnish::manage_vcl_file_content,
    replace => $varnish::manage_file_replace,
    audit   => $varnish::manage_audit,
    noop    => $varnish::noops,
  }

  # The whole varnish configuration directory can be recursively overriden
  if $varnish::source_dir {
    file { 'varnish.dir':
      ensure  => directory,
      path    => $varnish::config_dir,
      require => Package[$varnish::package],
      notify  => $varnish::manage_service_autorestart,
      source  => $varnish::source_dir,
      recurse => true,
      purge   => $varnish::bool_source_dir_purge,
      force   => $varnish::bool_source_dir_purge,
      replace => $varnish::manage_file_replace,
      audit   => $varnish::manage_audit,
      noop    => $varnish::noops,
    }
  }


  ### Include custom class if $my_class is set
  if $varnish::my_class {
    include $varnish::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $varnish::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'varnish':
      ensure    => $varnish::manage_file,
      variables => $classvars,
      helper    => $varnish::puppi_helper,
      noop      => $varnish::noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $varnish::bool_monitor == true {
    if $varnish::port != '' {
      monitor::port { "varnish_${varnish::protocol}_${varnish::port}":
        protocol => $varnish::protocol,
        port     => $varnish::port,
        target   => $varnish::monitor_target,
        tool     => $varnish::monitor_tool,
        enable   => $varnish::manage_monitor,
        noop     => $varnish::noops,
      }
    }
    if $varnish::service != '' {
      monitor::process { 'varnish_process':
        process  => $varnish::process,
        service  => $varnish::service,
        pidfile  => $varnish::pid_file,
        user     => $varnish::process_user,
        argument => $varnish::process_args,
        tool     => $varnish::monitor_tool,
        enable   => $varnish::manage_monitor,
        noop     => $varnish::noops,
      }
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $varnish::bool_firewall == true and $varnish::port != '' {
    firewall { "varnish_${varnish::protocol}_${varnish::port}":
      source      => $varnish::firewall_src,
      destination => $varnish::firewall_dst,
      protocol    => $varnish::protocol,
      port        => $varnish::port,
      action      => 'allow',
      direction   => 'input',
      tool        => $varnish::firewall_tool,
      enable      => $varnish::manage_firewall,
      noop        => $varnish::noops,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $varnish::bool_debug == true {
    file { 'debug_varnish':
      ensure  => $varnish::manage_file,
      path    => "${settings::vardir}/debug-varnish",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $varnish::noops,
    }
  }

}
