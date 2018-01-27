#!/bin/sh
set -ex

# Bootstrap service env vars
if [ ! -e $SNAP_DATA/edgex-services-env ]; then
    cp $SNAP/config/edgex-services-env $SNAP_DATA
fi

. $SNAP_DATA/edgex-services-env

# TODO: add check for core or metadata before starting...
echo "Starting mongo..."
if [ -e $MONGO_DATA_DIR ] ; then
    rm -rf $MONGO_DATA_DIR/*
else
    mkdir -p $MONGO_DATA_DIR
fi

$SNAP/mongo/launch-edgex-mongo.sh
