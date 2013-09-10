#!/bin/sh

PID=`ps ux | awk '/\/usr\/local\/bin\/node index.js 10001/ && !/awk/ {print $2}'`

if [ -n "$PID" ]; then
	kill -9 $PID
fi

cd /home/api/git/web/build
/usr/local/bin/node index.js 10001