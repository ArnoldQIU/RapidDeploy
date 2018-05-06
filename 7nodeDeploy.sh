#echo "Enther your github volume address:"
#read VOLUME
#git clone $VOLUME
for (( v = 1; v < $NUM_K8S+1; v++ ))
do
	#statements
	iptemp=$(echo SERVICE_IP$v)
echo 
'#!/bin/bash
set -u
set -e

for i in 1
do
    DDIR="qdata/c$i"
    mkdir -p $DDIR
    mkdir -p qdata/logs
    cp "keys/tm$i.pub" "$DDIR/tm.pub"
    cp "keys/tm$i.key" "$DDIR/tm.key"
    rm -f "$DDIR/tm.ipc"
    CMD="constellation-node --url=https://$iptemp:9000/ --port=9000 --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://${SERVER_IP1}:9000/"
    echo "$CMD >> qdata/logs/constellation$i.log 2>&1 &"
    $CMD >> "qdata/logs/constellation$i.log" 2>&1 &
done

DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    for i in 1
    do
	if [ ! -S "qdata/c$i/tm.ipc" ]; then
            DOWN=true
	fi
    done
done' > 'constellation-start$v.sh'
done
