#!/bin/sh
set -ex

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

echo "Starting core-data"
$SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
$SNAP/jar/core-data/core-data.jar &