#!/usr/local/bin/bash
#
############################################################################
# This software and the associated documentation are confidential and
# proprietary to Synopsys, Inc. Your use or disclosure of this software
# is subject to the terms and conditions of a written license agreement
# between you, or your company, and Synopsys, Inc.
############################################################################
#
# Name:	rotate_lic_server.sh
# 
# Desc: This script uses a pesudo round-robin scheduling to
#	randomly rearrange the order of license servers. This
#	helps in distributing the load on to different
#	servers evenly.
#	
#	You can use either LM_LICENSE_FILE from your environment
#	or use the default serves provided in the script. The
#	current default setting is: ${LICENSE_PATH}
#
# Usage:
#	rotate_lic_server.sh [-e] [-l lic_path] [cmd args]
#		-e   : use LM_LICENSE_FILE from env
#		-l   : Use lic_path as license server list
#		cmd  : Synopsys licensed application command
#		args : arguments to be passed to cmd
#
#	If cmd is not provided, then the script just echoes
#	the reordered license list. This option is useful
#	in startup scripts such as .login as follows:
#	export LM_LICENSE_FILE=`rotate_lic_server.sh -l <license_path>`
#
# Limitations: The script does not support <VENDOR>_LICENSE_FILE
#	variables.
#
############################################################################

#
# Customize your license server here.
LICENSE_PATH="26585@host1:26585@host2:26585@triad1,26585@triad2,26585@triad3"
OLD_LIC_PATH=$LICENSE_PATH

AWK=/bin/awk
OS=`uname`

case $OS in 
Linux) 
	AWK=/bin/awk
	;;
SunOS)
	AWK=/usr/bin/nawk
	;;
AIX)
	AWK=/usr/bin/nawk
	;;
HP-UX)
	AWK=/usr/bin/awk
	;;
esac

usage () {
	echo -e "\nusage: `basename $0` [-e | -s] [-l lic_path] <cmd [args]>"
	echo -e "\t-e   : use LM_LICENSE_FILE from env"
	echo -e "\t-s   : use SNPSLMD_LICENSE_FILE from env"
	echo -e "\t-l   : Use lic_path instead of default"

	echo -e "\tcmd  : Synopsys licensed application command"
	echo -e "\targs : arguments to be passed to cmd"

	echo -e "\nIf cmd is not provided, then the script just echoes"
	echo -e "the reordered license list. This option is useful"
	echo -e "in startup scripts such as .login as follows:"
	echo -e "\texport LM_LICENSE_FILE=\`rotate_lic_server.sh -l <license_path>\`"

	echo -e "\nThis script uses a pesudo round-robin scheduling to"
	echo -e "randomly rearrange the order of license servers. This"
	echo -e "helps in distributing the load on to different "
	echo -e "servers evenly.\n"
	echo -e "You can use either LM_LICENSE_FILE/SNPSLMD_LICENSE_FILE from your"
	echo -e "environment or use the default serves provided in the script.\n"

	exit -1
}

# 
# Process command line arguments
while getopts "l:eh" opt
do
	case $opt in 
		e)   LICENSE_PATH=$LM_LICENSE_FILE;; # Use env setting
		s)   LICENSE_PATH=$SNPSLMD_LICENSE_FILE;; # Use env setting
		l)   LICENSE_PATH=$OPTARG;; # Use path from command line
		h|*) usage;;
	esac
done
shift $(($OPTIND - 1))

#
# Get the number of license servers in the path
SERVER_COUNT=`echo $LICENSE_PATH|${AWK} -F: '{print NF+1}'`

#
# Select one server arbitrarily using $RANDOM
PIVOT=$(( ${RANDOM} % ${SERVER_COUNT} ))

# Split the license path using the pivot as
# the splitting point
NEW_LIC_PATH=`echo $LICENSE_PATH | cut -d: -f${PIVOT}-${SERVER_COUNT}`
if [ $PIVOT -gt 1 ]; then
	PREPIVOT=$(( ${PIVOT} - 1 ))
	NEW_LIC_PATH="$NEW_LIC_PATH:`echo $LICENSE_PATH | cut -d: -f1-$PREPIVOT`"
fi
export LM_LICENSE_FILE=$NEW_LIC_PATH

# See if we need to launch an application
if [ $# -gt 0 ]; then
	exec "$@"
else
	echo "$NEW_LIC_PATH"
fi
