#!/bin/bash
#
# infer-jdeps.sh
#
# It is sometimes needed to know which dependencies a Java application has having only its source code
# as a starting base. This script looks into the Java sources for the `import` statements, looking
# for such classes within the source tree (no external deps) or within the JARs contained in a specific
# library folder.
#
# Author:	Carlo Sciolla <skuro@skuro.tk>
# Version:	0.1