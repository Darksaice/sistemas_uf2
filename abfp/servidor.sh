#!/bin/bash

PORT=2021

echo "(0)Server ABFP"

echo "(1)Listening $PORT"

HEADER=`nc  -l -p $PORT`

echo "TEST! $HEADER"

PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "(4) RESPONSE"

if [ "$PREFIX" != "ABFP" ]; then

			echo "Error en la cabecera"
		
			sleep 1	
			echo "KO_CONN" | nc -q 1 $IP_CLIENT $PORT
			
			exit 1
fi

sleep 1
echo "OK_CONN" | nc -q 1 $IP_CLIENT $PORT

echo "(5) LISTEN"

HANDSHAKE=`nc -l -p $PORT`


exit 0
