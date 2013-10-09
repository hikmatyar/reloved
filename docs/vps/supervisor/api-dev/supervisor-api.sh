#!/bin/sh

PID=`ps ux | awk '/\/usr\/local\/bin\/node api.js 20001/ && !/awk/ {print $2}'`

if [ -n "$PID" ]; then
	kill -9 $PID
fi

cd /home/api-dev/git/web/build
/usr/local/bin/node api.js 20001