#!/bin/bash

PORT=2021
OUTPUT_PATH="salida_server/"

echo "(0)Server ABFP"

echo "(1)Listening $PORT"

HEADER=`nc  -l -p $PORT`

echo "TEST! $HEADER"

PREFIX=`echo $HEADER | cut -d " " -f 1`
IP_CLIENT=`echo $HEADER | cut -d " " -f 2`

echo "(4) RESPONSE HEADER"

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

echo "TEST HANDSHAKE"
if [ "$HANDSHAKE" != "THIS_IS_MY_CLASSROOM" ]; then
	echo "Error en el HANDSHAKE"
	sleep 1
	echo "KO_HANDSHAKE" | nc -q 1 $IP_CLIENT $PORT
	exit 2
fi

echo "(8) RESPONSE HANDSHAKE"
sleep 1
echo "YES_IT_IS" | nc -q 1 $IP_CLIENT $PORT

echo "(9) LISTEN FILE_NAME"

FILE_NAME=`nc -l -p $PORT`

PREFIX=`echo $FILE_NAME | cut -d " " -f 1`
NAME=`echo $FILE_NAME | cut -d " " -f 2`
NAME_MD5=`echo $FILE_NAME | cut -d " " -f 3`

echo "TEST $FILE_NAME"
if [ "$PREFIX" != "FILE_NAME" ]; then
	echo "Error en el nombre de archivo"
	sleep 1
	echo "KO_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT
	exit 3
fi

TEMP_MD5=`echo $NAME | md5sum | cut -d " " -f 1`

echo $NAME_MD5 $TEMP_MD5

if [ "$NAME_MD5" != "$TEMP_MD5" ]; then
	echo "Error: MD5 incorrect"
	sleep 1
	echo "KO_FILE_NAME_MD5" | nc -q 1 $IP_CLIENT $PORT
	exit 4
fi

echo "(12) RESPONSE FILE_NAME ($NAME)"
sleep 1
echo "OK_FILE_NAME" | nc -q 1 $IP_CLIENT $PORT

echo "(13) LISTEN DATA"
echo $OUTPUT_PATH $NAME
nc -l -p $PORT > $OUTPUT_PATH$NAME

echo "(16) RESPONSE DATA"
sleep 1
echo "OK_DATA" | nc -q 1 $IP_CLIENT $PORT

echo "(17) LISTEN"



exit 0
