#!/bin/sh
set -ex

MAX_TRIES=5
MONGO_DATA_DIR=$SNAP_DATA/mongo/db

# double check correct exit code for failure
if [ -z $SNAP_DATA ] || [ $SNAP_DATA == "" ] ; then
    echo "Fatal error: SNAP_DATA not set: $SNAP_DATA"
    exit 1
fi

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

# does this need to be fully qualified?
exec $SNAP/bin/mongod --dbpath $SNAP_DATA/mongo/db --smallfiles

while [ "$MAX_TRIES" -gt "0" ]; do
  mongo $SNAP/mongo/init_mongo.js && break
  sleep 5
  MAX_TRIES=`expr $MAX_TRIES - 1`
done

# Don't use due to inifinite loop...
#$SNAP/mongo/launch-edgex-mongo.sh
