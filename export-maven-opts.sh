#!/bin/bash

REMOTE_PORT=8787

export MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socketaddress=$REMOTE_PORT server=y suspend=n -Xms256m -Xmx512m -XX:PermSize=128m $MAVEN_OPTS"
