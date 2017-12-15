#!/bin/sh
set -ex

echo "Starting config-registry (consul)..."
$SNAP/bin/start-consul.sh

sleep 60

MONGO_DATA_DIR=$SNAP_DATA/mongo/db

echo "Starting config-seed..."
$SNAP/bin/start-config-seed.sh

echo "Starting mongo..."
if [ -e $MONGO_DATA_DIR ] ; then
    rm -rf $MONGO_DATA_DIR/*
else
    mkdir -p $MONGO_DATA_DIR
fi

$SNAP/mongo/launch-edgex-mongo.sh

echo "Starting logging"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-logging.log \
                   $SNAP/jar/support-logging/support-logging.jar &

sleep 65

echo "Starting notifications"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-notifications.log \
                   $SNAP/jar/support-notifications/support-notifications.jar &

sleep 33

echo "Starting metadata"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-metadata.log \
                   $SNAP/jar/core-metadata/core-metadata.jar &

sleep 60

echo "Starting core-data"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-data.log \
                   $SNAP/jar/core-data/core-data.jar &

sleep 60

echo "Starting command"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-command.log \
                   $SNAP/jar/core-command/core-command.jar &

sleep 60

echo "Starting scheduler"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-support-scheduler.log \
                   $SNAP/jar/support-scheduler/support-scheduler.jar &

sleep 60

echo "Starting export-client"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-export-client.log \
                   $SNAP/jar/export-client/export-client.jar &

sleep 60

echo "Starting export-distro"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-export-distro.log \
                   $SNAP/jar/export-distro/export-distro.jar &

sleep 60

echo "Starting device-virtual"
cd $SNAP/jar/device-virtual
echo "SNAP_COMMON=$SNAP_COMMON"

$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-device-virtual.log \
                   $SNAP/jar/device-virtual/device-virtual.jar &
