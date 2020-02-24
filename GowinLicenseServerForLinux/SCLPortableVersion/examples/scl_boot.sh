##!/bin/sh
##
## Start/stop Synopsys Tools License Servers
##
## This is an example of boot script that automatically starts
## up a license server during the machine boot time. It uses a
## license file /remote/src/keys/2005.06/nls-key and daemon 
## lmgrd in /remote/src/keys/2005.06/bin-sun5. The log file is
## /remote/src/keys/2005.06/.license.`hostname`
##
#
#killproc() {            # kill the named process(es)
#        pid=`/usr/bin/ps -e |
#             /usr/bin/grep $1 |
#             /usr/bin/sed -e 's/^  *//' -e 's/ .*//'`
#        [ "$pid" != "" ] && kill $pid
#}
#
#filename=.license.`hostname`
#
##
## Here we go...
##
#
#case "$1" in
#
#'start')
#
#  if [ -f /remote/src/keys/2005.06/nls-key ]; then
#    echo -n " Starting Network License Server:"
#    (PATH=/bin:/usr/bin:/usr/etc:/usr/ucb; cd /remote/src/keys/2005.06; \
#	 su src -c "mv -f $filename $filename.old"; \
#	 su src -c "bin-sun5/lmgrd -c nls-key -l  $filename &")
#    echo -n " Synopsys lmgrd"
#  fi
#  ;;
#
#'stop')
#
#  killproc la_dmon
#  killproc synopsysd
#  killproc lmgrd
#  ;;
#
#*)
#  
#  echo "Usage: /etc/init.d/nls { start | stop }"
#  ;;
#
#esac




