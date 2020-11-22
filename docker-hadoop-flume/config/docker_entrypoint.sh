#!/bin/bash

service ssh start
/opt/hadoop/sbin/start-dfs.sh
/opt/hadoop/sbin/start-yarn.sh

/opt/hadoop/bin/hadoop fs -mkdir /flume-demo

/bin/bash

