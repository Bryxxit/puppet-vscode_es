
# puppet-vscode_es

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with vscode_es](#setup)
    * [What vscode_es affects](#what-vscode_es-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vscode_es](#beginning-with-vscode_es)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module will install and manage a central Visual Studio Code Editor Service you can use to optimize your Puppet development cycle.

The Language server used can be found at [https://github.com/lingua-pupuli/puppet-editor-services](https://github.com/lingua-pupuli/puppet-editor-services) where it is maintained by Glennsarti and jpogran (many thanks!)

## Setup

### What vscode_es affects **OPTIONAL**

The module will use Git (vcsrepo module) to get the editor service binaries from github.

It will setup a systemd service with the requested parameters and (if needed) will create a log file in the configured location.

### Setup Requirements **OPTIONAL**

Make sure your server can access github. This module will (for now) not work with a local repo. It will always try to pull from the offical github repo.

### Beginning with vscode_es

`include vscode_es` is enough to get you up and running. To pass in parameters specifying which servers to use:
```puppet
class{'vscode_es':
    port => 9876,
}
```

## Usage

All parameters for the vscode_es module are contained within the main `vscode_es` class, so for any function of the module, set the options you want. See the common usages below for examples.

**Install and enable the editor service**
```puppet
include vscode_es
```

**Listen on custom IP and port**
```puppet
class{'vscode_es':
    ip => '192.168.0.2',
    port => 9876,
}
```

**Enable debug log**
```puppet
class{'vscode_es':
    debug => true,
    debugpath => '/var/log/puppet/languageserver',
}
```

## Reference

see [REFERENCE.MD](REFERENCE.md)

## Limitations

This code can only run on *nix systems using `systemd` (older `init.d` scripts are not included)

## Development

Feedback, bugfixes, feature requests or Pull Requests are welcome.
