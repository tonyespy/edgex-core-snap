#!/bin/sh
set -ex

# Bootstrap service env vars
if [ ! -e $SNAP_DATA/edgex-services-env ]; then
    cp $SNAP/config/edgex-services-env $SNAP_DATA
fi

. $SNAP_DATA/edgex-services-env

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

if [ $SUPPORT_LOGGING = "y" ] ; then
    sleep 60
    echo "Starting logging"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-logging.log \
                   $SNAP/jar/support-logging/support-logging.jar &
fi

if [ $SUPPORT_NOTIFICATIONS = "y" ] ; then
    sleep 65
    echo "Starting notifications"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-notifications.log \
                   $SNAP/jar/support-notifications/support-notifications.jar &
fi


if [ $CORE_METADATA = "y" ] ; then
    sleep 33
    echo "Starting metadata"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dspring.cloud.consul.enabled=true \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-metadata.log \
                   $SNAP/jar/core-metadata/core-metadata.jar &
fi

if [ $CORE_DATA = "y" ] ; then
    sleep 60
    echo "Starting core-data"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dspring.cloud.consul.enabled=true \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-data.log \
                   $SNAP/jar/core-data/core-data.jar &
fi


if [ $CORE_COMMAND = "y" ] ; then
    sleep 60
    echo "Starting command"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-core-command.log \
                   $SNAP/jar/core-command/core-command.jar &
fi


if [ $SUPPORT_SCHEDULER = "y" ] ; then
    sleep 60
    echo "Starting scheduler"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-support-scheduler.log \
                   $SNAP/jar/support-scheduler/support-scheduler.jar &
fi

if [ $EXPORT_CLIENT = "y" ] ; then
    sleep 60
    echo "Starting export-client"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-export-client.log \
                   $SNAP/jar/export-client/export-client.jar &
fi

if [ $EXPORT_DISTRO = "y" ] ; then
    sleep 60
    echo "Starting export-distro"

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-export-distro.log \
                   $SNAP/jar/export-distro/export-distro.jar &
fi

if [ $DEVICE_VIRTUAL = "y" ] ; then
    sleep 60
    echo "Starting device-virtual"

    cd $SNAP/jar/device-virtual
    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
                   -Dlogging.file=$SNAP_COMMON/edgex-device-virtual.log \
                   $SNAP/jar/device-virtual/device-virtual.jar &
fi
