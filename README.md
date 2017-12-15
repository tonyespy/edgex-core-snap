# EdgeX Foundry Core Snap

This project contains snap packaging for the core services of the EdgeX Foundry
[Barcelona](https://wiki.edgexfoundry.org/display/FA/Barcelona) (0.2.1) release.

This is a very early experiment, and as such, there are quite a few limitations
and manual steps involved.

The snap builds all of EdgeX's core micro services, and also includes export-client,
export-distro, and the device-virtual service.

## Building

This snap can be built on an Ubuntu 16.04 LTS system:

 * install snapcraft
 * clone this git repo
 * cd edgex-core-snap
 * snapcraft

This should produce a binary snap package called edgex-core-snap_0.2.1+barca-1_amd64.snap.

## Installation

As the snap currently has not been published to the store, it needs to be side-loaded, which
requires *--dangerous* to be specified when running *snap install*, this option tells snapd
to ignore the fact that binary snap isn't signed.

## Configuration

The hardware-observer and system-observe interfaces needs to be connected after installation
using the following commands:

`$ snap connect edgex-core-snap:hardware-observe core:hardware-observe`

`$ snap connect edgex-core-snap:system-observe core:system-observe`

## Starting/Stopping EdgeX

To start all the EdgeX microservices, use the following command:

`$ edgex-core-snap.start-edgex`

To stop all the EdgeX microservices, use the following command:

`$ edgex-core-snap.stop-edgex`

### Enabling/Disabling service startup

It's possible to a effect which services are started by the start-edgex script by editing
a file called `edgex-services-env` which can be found in the `/var/snap/edgex-core-snap/current`
($SNAP_DATA).

**Note** - this file is created by the start-edgex script, so the script needs to be run at
least once to copy the default version into place.

## Limitations

 * the snap is large (~630M), however it only includes a single JRE, shared by all services. No attempt has
   been made to optimize the size.

 * none of the services are actually defined as such in snapcraft.yaml, instead shell-scripts are used
   to start and stop the EdgeX microservices.

 * the snap requires some file re-orgnization to ensure that the correct copyright/license files are
   copied into place.

   



