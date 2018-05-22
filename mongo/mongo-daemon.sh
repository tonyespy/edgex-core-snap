#!/bin/bash -ex

# Setup mongo data directory
MONGO_DATA_DIR=$SNAP_DATA/mongo/db
if [ -e $MONGO_DATA_DIR ] ; then
    rm -rf $MONGO_DATA_DIR/*
else
    mkdir -p $MONGO_DATA_DIR
fi

# Start the mongo daemon
mongod --dbpath $SNAP_DATA/mongo/db --logpath $SNAP_COMMON/mongodb.log --smallfiles
