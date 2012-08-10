#!/bin/sh

# default location of emacsclient for OS X installations
EC="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"

# start Emacs daemon in case if it's not running yet
if [ ! -e $TMPDIR/emacs$UID/server ]
then
	/Users/skuro/bin/emacs-daemon
fi

# -n : return immediately
ARGS="-n $@"

# apparently, when the daemon runs with no windows open it still lists
# one frame.
WINDOWED=`$EC -e "window-system"`
if [ "xnil" == "x$WINDOWED" ]
then
    # create a new Emacs window
    ARGS="-c $ARGS"
fi

$EC $ARGS
