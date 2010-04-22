#!/bin/bash

read -p "What are you doing? " -e input
curl --basic --user $username:$password --data status="$input" http://twitter.com/statuses/update.xml > /dev/null


