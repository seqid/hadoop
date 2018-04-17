#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

/etc/init.d/ssh start
chmod +x $HADOOP_PREFIX/etc/hadoop/*.sh
mkdir -p /tmp/hadoop-root/dfs/name
$HADOOP_PREFIX/bin/hdfs namenode -format
$HADOOP_PREFIX/sbin/start-all.sh

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
