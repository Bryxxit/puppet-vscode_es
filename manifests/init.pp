# This module will install and manage a Visual Studio Code Editor Service for Puppet Development.
# The editor Service used is the one developed by Glenn Sarti and James Pogran of Puppet and maintained
# on Github at https://github.com/lingua-pupuli/puppet-editor-services
#
# More info on how to use this editor service can be found there
#
# @summary This module will install and manage a Visual Studio Code Editor Service for Puppet Development.
#
# @param port
#   TCP Port to listen on.  If not set, a random port will be used
#
# @param ipaddr
#   IP Address to listen on (0.0.0.0 for all interfaces).
#   Also, if IPv6 is activated, the editor service will only listen on the IPv6 address by default, if you want it to listen to IPv4
#   explicitly set this to 0.0.0.0. When no value is set, the value will fall back to `localhost`
#
# @param nostop
#   Do not stop the language server once a client disconnects.
#
# @param timeout
#   Stop the language server if a client does not connection within TIMEOUT seconds.
#   A value of zero will not timeout.
#
# @param debug
#   Output debug information.
#
# @param debugpath
#   Either specify a filename or 'STDOUT' as a location for your debug log
#   This variable will only be used when $debug is set to true.
#
# @params slowstart
#   Delay starting the Language Server until Puppet initialisation has completed.
#
# @param filecache
#   Enables the file system cache for Puppet Objects (types, class etc.)
#
# @param workspace
#   The workspace or file path that will be used to provide module-specific functionality.
#   Default is no workspace path.
#
# @param installpath
#   The location in which the Puppet Editor Services will be installed on your system
#
# @param installuser
#   User used to execute the bundle install on your system
#
# @param installgroup
#   Group used to execute the bundle install command on the system
#
# @param manageservice
#   enable this to create the necesary configs for your OS to manage the Editor Services as a daemon
#
# @param enable
#   If set, this will make sure that the Editor Services are started after a server reboot
#
# @param version
#   If set, the editor service will be pinned to a specific version of the code. If left blank, the module
#   will follow the latest release
#
# @example
#   include vscode_es
class vscode_es(
  Optional[Integer] $port          = undef,
  Optional[String]  $ipaddr        = undef,
  Boolean           $nostop        = false,
  Integer           $timeout       = 10,
  Boolean           $debug         = false,
  Optional[String]  $debugpath     = undef,
  Boolean           $slowstart     = false,
  Boolean           $filecache     = false,
  Optional[String]  $workspace     = undef,
  String            $installpath   = '/opt/puppet-editor-services',
  String            $installuser   = 'root',
  String            $installgroup  = 'root',
  Boolean           $manageservice = true,
  Boolean           $enable        = true,
  Optional[String]  $version       = undef,
) {

  # Validate your input
  #=====================
  # Debug option validation
  if ($debug and !$debugpath) {
    fail('If debug == true, than set a $debugpath as well!')
  }
  if ($debugpath and !$debug) {
    notice('The debugpath will not be set if $debug == false')
  }

  #Version validation
  if $version{
    $_version = $version
  } else {
    $_version = 'latest'
  }
  vcsrepo {$installpath:
    ensure   => 'present',
    provider => 'git',
    source   => 'https://github.com/lingua-pupuli/puppet-editor-services.git',
    revision => $_version,
  }

  exec {'bundle install':
    user        => $installuser,
    group       => $installgroup,
    command     => 'bundle install',
    cwd         => $installpath,
    path        => '/bin:/usr/bin:/usr/local/bin',
    unless      => 'bundle check',
    require     => Vcsrepo[$installpath],
    logoutput   => on_failure,
    environment => "HOME='${installpath}'",
  }

  if $debug {
    file {$debugpath:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Vcsrepo[$installpath]
    }
  }

  if $manageservice {
    file {'/etc/systemd/system/puppet-languageserver.service':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => epp('vscode_es/puppet-es.service.epp',{
        port      => $port,
        ipaddr    => $ipaddr,
        nostop    => $nostop,
        timeout   => $timeout,
        debug     => $debug,
        debugpath => $debugpath,
        slowstart => $slowstart,
        filecache => $filecache,
        workspace => $workspace
      }),
      require => Vcsrepo[$installpath]
    }

    service { 'puppet-languageserver':
      ensure  => 'running',
      enable  => true,
      require => File['/etc/systemd/system/puppet-languageserver.service']
    }
  }

}
