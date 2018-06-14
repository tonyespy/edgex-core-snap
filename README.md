# EdgeX Foundry Core Snap
This project contains snap packaging for the EgdeX Foundry reference implementation
micros services.

This is an early experiment, and as such, there are quite a few limitations and
manual steps involved.

The snap contains all of the EdgeX core micro services, export services, support
service, and the device-virtual service.  There currently are two versions available
in the snap store, one based on the 'Barcelona' release, and one based on the recent
'California Preview' release.

## Installation Requirements
The snap can be installed on any system running snapd, however for full confinement,
the snap must be installed on an Ubuntu 16.04 LTS or later Desktop or Server, or a system
running Ubuntu Core 16.

## Installation
There are amd64 and arm64 versions of both releases available in the store.  You can
see the revisions available for your machine's architecture by running the command:

`$ snap info edgexfoundry-core`

### Barcelona
The Barcelona based snap can be installed with:

`$ sudo snap install edgexfoundry-core --edge`

### California Preview
The California Preview based snap can be installed with:

`$ sudo snap install edgexfoundry-core --channel=cali/edge`

**Note** - this snap has only been tested on Ubuntu 16.04 LTS Desktop/Server and Ubuntu Core 16.

**WARNING** - as this snap is still considered experimental, please don't install it
on a machine that you can't live without.  Use a VM or cloud server instance, or a spare
desktop/server.

## Configuration
The hardware-observe, process-control, and system-observe interfaces needs to be connected after installation
using the following commands:

`$ snap connect edgexfoundry-core:hardware-observe core:hardware-observe`

`$ snap connect edgexfoundry-core:hardware-observe core:process-control`

`$ snap connect edgexfoundry-core:system-observe core:system-observe`

## Starting/Stopping EdgeX
To start all the EdgeX microservices, use the following command:

`$ edgexfoundry-core.start-edgex`

To stop all the EdgeX microservices, use the following command:

`$ edgexfoundry-core.stop-edgex`

**WARNING** - don't start the EdgeX snap on a system which is already running mongoDB or Consul.

### Enabling/Disabling service startup
It's possible to a effect which services are started by the start-edgex script by editing
a file called `edgex-services-env` which can be found in the `/var/snap/edgex-core-snap/current`
($SNAP_DATA).

**Note** - this file is created by the start-edgex script, so the script needs to be run at
least once to copy the default version into place.

## Limitations

### Barcelona
  * the Barcelona snap is large (~590M), however it only includes a single JRE, shared by all services.

  * none of the services are actually defined as such in snapcraft.yaml, instead shell-scripts are used
    to start and stop the EdgeX microservices and dependent services such as consul and mongo.

  * the start script will fail on a sytem which has more than one local IP address, or active bridge
    network devices as the current consul start command doesn't specify a specific IP address for the agent.

### California (0.5.1+cali-20180322)
  * the California snap is much smaller (~400MB)

  * some of the new Go-based core services (export-*) currently don't load configuration from Consul

  * the new Go-based export services don't generate log files, and export-client has a broken health check

## Building

This snap can be built on an Ubuntu 16.04 LTS system:

 * install snapcraft
 * clone this git repo
 * cd edgex-core-snap
 * snapcraft

This should produce a binary snap package called edgex-core-snap_<latest version>_<arch>.snap.
