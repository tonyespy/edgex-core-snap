#!/bin/sh
set -e

count=10

while [ $count > 0 ] ; do

    CONSUL_RUNNING=`curl http://127.0.1.1:8500/v1/catalog/service/consul`

    if [ $CONSUL_RUNNING = "[]" ] ; then
	sleep 20
    else
	break
    fi
done

# start config-seed if consul is up
if [ $CONSUL_RUNNING != "[]" ] ; then
    exec $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
	 $SNAP/jar/config-seed/core-config-seed.jar
fi

    




