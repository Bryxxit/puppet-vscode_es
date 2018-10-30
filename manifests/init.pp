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
#   explicitly set this to 0.0.0.0
#   Default value: 'localhost'
#
# @param nostop
#   Do not stop the language server once a client disconnects.
#   Default value: false
#
# @param timeout
#   Stop the language server if a client does not connection within TIMEOUT seconds.
#   A value of zero will not timeout.
#   Default value: 10
#
# @param debug
#   Output debug information.
#   Default value: false
#
# @param debugpath
#   Either specify a filename or 'STDOUT' as a location for your debug log
#   This variable will only be used when $debug is set to true.
#
# @params slowstart
#   Delay starting the Language Server until Puppet initialisation has completed.
#   Default value: false
#
# @param filecache
#   Enables the file system cache for Puppet Objects (types, class etc.)
#   Default value: false
#
# @param workspace
#   The workspace or file path that will be used to provide module-specific functionality.
#   Default is no workspace path.
#
# @param installpath
#   The location in which the Puppet Editor Services will be installed on your system
#   Default value: '/opt/puppet-editor-services'
#
# @param installuser
#   User used to execute the bundle install on your system
#   Default value: 'root'
#
# @param installgroup
#   Group used to execute the bundle install command on the system
#   Default value: 'root'
#
# @param manageservice
#   enable this to create the necesary configs for your OS to manage the Editor Services as a daemon
#   Default value: true
#
# @param enable
#   If set, this will make sure that the Editor Services are started after a server reboot
#   Default value: true
#
# @param version
#   If set, the editor service will be pinned to a specific version of the code. If left blank, the module
#   will follow the latest release
#   Default value: undef
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
  vcsrepo {$installpath:
    ensure   => 'present',
    provider => 'git',
    source   => 'https://github.com/lingua-pupuli/puppet-editor-services.git',
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
}
