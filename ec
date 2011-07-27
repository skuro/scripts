#!/bin/sh

if [ ! -e $TMPDIR/emacs$UID/server ]
then
	~/bin/emacs-daemon
fi

emacsclient -n $@
