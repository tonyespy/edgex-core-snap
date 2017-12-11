#!/bin/sh
set -x

count=10

while [ "$count" -gt 0 ] ; do
    CONSUL_RUNNING=`curl http://127.0.0.1:8500/v1/catalog/service/consul`

    if [ $? -ne 0] || [ $CONSUL_RUNNING = "[]" ] || [ $CONSUL_RUNNING = "" ]; then
	sleep 20
    else
	break
    fi
done

# start config-seed if consul is up
#
# TODO: this success check could be improved...
if [ $CONSUL_RUNNING != "[]" ] ; then
    cd $SNAP/jar/config-seed/

    $SNAP/jre/bin/java -jar -Djava.security.egd=file:/dev/urandom -Xmx100M \
    $SNAP/jar/config-seed/core-config-seed.jar
fi

    




