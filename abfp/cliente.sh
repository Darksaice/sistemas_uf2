#!/bin/bash

PORT=2021

IP_CLIENT="127.0.0.1"
IP_SERVER="127.0.0.1"

echo "Cliente ABFP"

echo "(2) Sending Headers"

echo "ABFP $IP_CLIENT" | nc -q 1 $IP_SERVER $PORT

echo "(3) Listening $PORT"

RESPONSE=`nc -l -p $PORT`
if [ "$RESPONSE" != "OK_CONN" ]; then
	echo "No se ha podido conectar al servidor"
	exit 1
fi

echo "(6) HANDSHAKE"

sleep 1
echo "THIS_IS_MY_CLASSROOM" | nc -q 1 $IP_SERVER $PORT

exit 0
