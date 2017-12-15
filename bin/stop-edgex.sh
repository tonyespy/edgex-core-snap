#!/bin/sh
set -ex

# Bootstrap service env vars
if [ ! -e $SNAP_DATA/edgex-services-env ]; then
    cp $SNAP/config/edgex-services-env $SNAP_DATA
fi

. $SNAP_DATA/edgex-services-env

if [ $DEVICE_VIRTUAL = "y" ] ; then
    pid=`ps -ef | grep device-virtual | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing device-virtual ($pid) service"
	kill -9 $pid
    fi
fi

if [ $EXPORT_DISTRO = "y" ] ; then
    pid=`ps -ef | grep export-distro | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing export-distro ($pid) service"
	kill -9 $pid
    fi
fi

if [ $EXPORT_CLIENT = "y" ] ; then
    pid=`ps -ef | grep export-client | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing export-client ($pid) service"
	kill -9 $pid
    fi
fi

if [ $SUPPORT_SCHEDULER = "y" ] ; then
    pid=`ps -ef | grep support-scheduler | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing support-scheduler ($pid) service"
	kill -9 $pid
    fi
fi

if [ $CORE_COMMAND = "y" ] ; then
    pid=`ps -ef | grep core-command | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing core-command ($pid) service"
	kill -9 $pid
    fi
fi

if [ $CORE_DATA = "y" ] ; then
    pid=`ps -ef | grep core-data | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing core-data ($pid) service"
	kill -9 $pid
    fi
fi

if [ $CORE_METADATA = "y" ] ; then
    pid=`ps -ef | grep core-metadata | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing core-metadata ($pid) service"
	kill -9 $pid
    fi
fi

if [ $SUPPORT_NOTIFICATIONS = "y" ] ; then
    pid=`ps -ef | grep support-notifications | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing support-notifications ($pid) service"
	kill -9 $pid
    fi
fi

if [ $SUPPORT_LOGGING = "y" ] ; then
    pid=`ps -ef | grep support-logging | grep -v grep | awk '{print $2}'`

    if [ $pid != "" ] ; then
	echo "killing support-logging ($pid) service"
	kill -9 $pid
    fi
fi

echo "shutting down mongod..."
$SNAP/bin/mongod --shutdown --dbpath $SNAP_DATA/mongo/db

echo "shutting down config/registry..."
/usr/bin/killall consul
