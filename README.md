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

## Limitations

 * the snap must be installed using --devmode; Work has started on confinement, however there are still some
   remaining issues to be resolved.

 * the snap is large (~678M), however it only includes a single JRE, shared by all services. No attempt has
   been made to optimize the size.

 * none of the services are actually defined as such in snapcraft.yaml, instead a shell-script app called
   start-edgex.sh is used to start all of the micro services.  This script is loosely based on the script
   run-it.sh from the EdgeX developer-scripts project.

 * there currently isn't an app provided to stop the micro services, you'll need to bring everything
   down manually before installing a new version.  Be careful to ensure that you aren't already
   running instances of java, mongod, or consul.

 * the snap requires some file re-orgnization to ensure that the correct copyright/license files are
   copied into place.

   



