#!/bin/bash

if [ ! -e /tmp/emacs$UID/server ]
then
	~/bin/emacs-daemon
fi

emacsclient -n $@
