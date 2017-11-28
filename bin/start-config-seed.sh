#!/bin/sh
set -e

count=10

while [ "$count" -gt 0 ] ; do

    CONSUL_RUNNING=`curl http://127.0.1.1:8500/v1/catalog/service/consul`

    if [ $CONSUL_RUNNING = "[]" ] ; then
	sleep 20
    else
	break
    fi
done

echo "CONSUL_RUNNING=$CONSUL_RUNNING"

# start config-seed if consul is up
if [ $CONSUL_RUNNING != "[]" ] ; then
    cd $SNAP/jar/config-seed/

    exec $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
    $SNAP/jar/config-seed/core-config-seed.jar
fi

    




