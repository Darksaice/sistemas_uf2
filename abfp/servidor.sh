#!/bin/bash

PORT=2021

echo "(0)Server ABFP"

echo "(1)Listening $PORT"

nc  -l -p $PORT
