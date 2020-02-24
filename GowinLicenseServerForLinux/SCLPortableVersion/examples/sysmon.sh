#!/usr/local/bin/bash
#
# Name	:	sysmon.sh
#
# Desc	:	sysmon.sh is an utility script that is intended
#		to aid in identifying configuration issues that
#		result in Licensing errors.
#
# Usage	:	Script can be run in two ways:
#		1. sysmon.sh -p <port> -s -r <loopInterval> [-l logfile]
#			-p Specify the snpslmd daemon port #
#		  	-s Print only socket summary. No other information
#		     	   is collected
#			-r option allows the script to run infinitely, while 
#			   sampling the system state periodically.
#		2. sysmon.sh -p <port> [-l logfile]
#		   This can be used to log the system state at any instant
#
# Log	:	Output of this file will be saved under /tmp in the
#		following format:
#			sysmon_DDMonYY:HHMM_$pid.log
#
# Env	:	Uses SNPSLMD_PATH to locate FLEXlm bianries. The binaries
#		are used to determine the release versions for lmgrd and
#		Synopsys daemon. The path should refer to the root install
#		directory.
#
# Supported Platforms: The following platforms are currently supported:
#	1. Solaris
#	2. Linux
#	3. HP-UX
#	4. AIX
#
# REVISIONS
# 
# Date		Author		Comments
# ----		------		--------
# 12-jun-06	Ravi		Added lsof support for Solaris and Linux.
#

 

let loopIntvl=0
let daemonPort=0
ECHO='echo -e'
HOST=`hostname`

# Functions
printExit() {
 
	$ECHO "\n\nCompleted. Logfile is located at $logFile"
	exit 0
}

usage() {

	cat << EOT

Usage	:	Script can be run in two ways:
		% sysmon.sh -p port -s -r <loopInterval> [-l logfile]
		  -p Specify the snpslmd daemon port #
		  -c Specify client hostname. Socket connections
		     between host and client will be printed.
		  -s Print only socket summary. No other information
		     is collected
		  -r option allows the script to run infinitely, while 
			sampling the system state at every loopInterval secs.
		% sysmon.sh -p port [-l logfile]
		  This can be used to log the system state at any instant
	
Note	:	Please set SNPSLMD_PATH to the directory where Synopsys
		License executables are located.
		(% ls \$SNPSLMD_PATH/lmgrd -- should list lmgrd file)

EOT
	exit
}


# getSysInfo prints system configuration information.
# The level of output depends on the underlying
# OS.
getSysInfo() {

	$ECHO "\n======================================================"
	$ECHO "=========== System Configuration ====================="
	$ECHO "======================================================"

	uname -a
	$ECHO "\nUser Limits:" 
	$ECHO "------------" 
	ulimit -a

	case $OS in
	Linux) 
		$ECHO "\nLinux Distro : " 
		cat /etc/issue
		$ECHO "\nKernel Settings"
		$ECHO "---------------"
		/sbin/sysctl -a
		;;
	SunOS)
		
		$ECHO "\nProcessor Information" 
		psrinfo -v
		isainfo -v
		cat /etc/release

		$ECHO "\nTCP Settings"
		$ECHO "------------"
		ndd_params=`$NDD /dev/tcp \? \
				| grep write \
				| grep -v close_wait \
				| awk '{print $1}'`
		for tcp_param in $ndd_params; do
			$ECHO "\t$tcp_param : "  \
			`$NDD /dev/tcp $tcp_param`
		done

		$ECHO "\nSystem Definition:"
		$ECHO "------------------"
		/usr/sbin/sysdef | egrep -v "^drv|^misc|^strmod|^fs|^sys"
		
		$ECHO "\nSystem Information:" 
		$ECHO "--------------------" 
		/usr/local/bin/sysinfo
		;;
        AIX)
		$ECHO "\nProcessor Information" 
		lsconf -ckLms
		echo "OS Level: \c" `oslevel`

		$ECHO "\nTCP Settings"
		$ECHO "------------"
		/usr/sbin/no -a

		$ECHO "\nSystem Information:" 
		$ECHO "--------------------" 
		lsconf
		;;
	HP-UX)
		$ECHO "\nProcessor Information" 
		echo "Kernel Bits: " `getconf KERNEL_BITS`

		$ECHO "\nSystem Definition:"
		$ECHO "------------------"
		/usr/sbin/sysdef | egrep -v "^drv|^misc|^strmod|^fs|^sys"
		
		
		$ECHO "\nSystem Information:" 
		$ECHO "--------------------" 
		/usr/sbin/kmtune 

		$ECHO "\nTCP Settings"
		$ECHO "------------"
		ndd_params=`$NDD /dev/tcp \? \
				| grep write \
				| grep -v close_wait \
				| awk '{print $1}'`
		for tcp_param in $ndd_params; do
			$ECHO "\t$tcp_param : "  \
			`$NDD /dev/tcp $tcp_param`
		done
		;;
	esac
}

# This function samples system state at periodic
# intervals.
getDynInfo() {

	date
	$ECHO "Network Interfaces: "; 
	$ECHO "-------------------"; 
	netstat -i
	$ECHO "\nNetstat Summary: "; 
	$ECHO "----------------"; 
	netstat -s$netstatOpt
	getSocketSummary
	$ECHO "\n*****************************"
	$ECHO "*****************************\n"
}

# This function records the socket connections with specific IP
# at regular intervals.
getSockInfo() {
	$ECHO "Current connections with $destIP\n" 
	$ECHO "$ssHeader\n"
	ss -t -a -e -n | grep "$myIP.*$destIP" >> $logFile 2>/dev/null
	$ECHO "\n"
}

# Print the current socket status for a given port
# Based on command line args, the output is either in long
# or short format.
getSocketSummary() {

	# get the number of idle sockets for daemon
	case $OS in
	Linux) 
		idleSock=`lsof -p $DAEMON_PID | grep "can't identify protocol" | wc -l | $AWK_CMD '{print $1}' `
		;;
	SunOS)
		idleSock=`lsof -p $DAEMON_PID | egrep -e "clearcase8.*(IDLE)" | wc -l | $AWK_CMD '{print $1}' `
		;;
	*)
		idleSock="N/A"
		;;
	esac

	if [ ! -z "$summaryOnly" ]; then
		timestamp=`date +'%D-%T'`
		netstat -$netstatSum | grep "$daemonPort" | \
		$AWK_CMD -v ts="$timestamp" -v is="$idleSock" '
		     /CLOSE_WAIT/ { close_wait++ }
		     /TIME_WAIT/ { time_wait++ }
		     /ESTABLISHED/ { estab++ }
		     END { printf("%s\t %d\t\t%d\t\t%d\t\t%s\t%d\n", ts,
				close_wait, time_wait, estab, is,
				close_wait + time_wait + estab + is)}'
	else
		netstat -$netstatSum | grep "$daemonPort" | \
		$AWK_CMD -v port="$daemonPort" -v is="$idleSock" '
		     BEGIN { printf ("\nSocket summary for port %s\n", port)
			     printf ("-----------------------------------\n") }
		     /CLOSE_WAIT/ { close_wait++ }
		     /TIME_WAIT/ { time_wait++ }
		     /ESTABLISHED/ { estab++ }
		     END { printf("Sockets in CLOSE_WAIT: %d\n", close_wait)
			printf("Sockets in TIME_WAIT: %d\n", time_wait)
			printf("Sockets in ESTABLISHED: %d\n", estab)
			printf("Sockets in IDLE: %s\n", is)
			printf("Total sockets on server: %d\n", \
				close_wait + time_wait + estab + is)}'
	fi
}

# MAIN starts here
logFile=/tmp/sysmon_`date '+%d%b%y_%H%M'`_$$.log
OS=`uname`
typeset -i loopIntvl daemonPort

while getopts "p:r:l:c:hs" opt
do
	case $opt in
		p)  let daemonPort=$OPTARG   # Daemon Port
		    if [ $? -ne 0 ]; then
			$ECHO "\nERROR: Invalid Port number" \
				"($OPTARG) specified."
			usage
		    fi
                    ;;
		r)  let loopIntvl=$OPTARG;;  # Loop Interval
		l)  logFile=$OPTARG;;	     # Logfile
		c)  CLIENT=$OPTARG;;
		s)  summaryOnly=1;;	     # Summary Flag
		h|*) usage;;
    esac
done
shift $(($OPTIND - 1))

# Validate Daemon Port
if [ $daemonPort -eq 0 ]; then
	$ECHO "\nERROR: Port number not specified"
	usage
fi

# Check if ss is in the path
if [ ! -z "$CLIENT" ]; then
	export PATH=$PATH:/usr/sbin
	command -v ss >/dev/null 2>&1 || { echo >&2 "Need to have ss command in path. Exiting."; exit 1; }
fi

trap printExit EXIT 

# get OS specific options and commands
case $OS in
Linux) 
	netstatOpt="nt"
	netstatSum="nt"
	AWK_CMD=/bin/awk
	;;
SunOS)
	netstatOpt="sP tcp"
	netstatSum="P tcp"
	AWK_CMD=/usr/bin/nawk
	NDD=/usr/sbin/ndd
	;;
AIX)
	netstatOpt="sp tcp"
	netstatSum="na"
	AWK_CMD=/usr/bin/nawk
	NDD=/usr/bin/ndd
	;;
HP-UX)
	netstatOpt="sp tcp"
	netstatSum="na"
	AWK_CMD=/usr/bin/awk
	NDD=/usr/bin/ndd
	;;
esac

# Determine the PID of snpslmd daemon
DAEMON_PID=`/bin/ps -ef|grep snpslmd|grep -v grep |$AWK_CMD '{print $2}'`

if [ $loopIntvl  -ne 0 ]; then
	$ECHO "\n\nOutput will be logged to $logFile"
fi

# If client info provided filter on client
if [ ! -z "$CLIENT" ]; then
	# Get source and dest IPs
	myIP=`host $HOST | cut -d' ' -f4`
	destIP=`host $CLIENT | cut -d' ' -f4`
	ssHeader=`/usr/sbin/ss -t --a -e -n | head -1`
fi

# 10-Mar-06: Added support for Socket Summary monitoring
if [ ! -z "$summaryOnly" ]; then

	# Print header to file
	$ECHO "Socket Summary for Port $daemonPort" >> $logFile
	$ECHO "TIMESTAMP \t\tCLOSE_WAIT\tTIME_WAIT\tESTABLISHED\tIDLE\tTOTAL" \
		>> $logFile
	$ECHO "--------- \t\t----------\t---------\t-----------\t----\t-----" \
		>> $logFile
	# get only socket information
	while true; do
		getSocketSummary >> $logFile 2>/dev/null
		if [ $loopIntvl  -eq 0 ]; then
			break
		fi
		$ECHO "\nHit Ctrl-C to stop ... \c"
		sleep $loopIntvl
	done
	exit 0
fi

date >> $logFile
if [ -z "$SNPSLMD_PATH" ]; then
	$ECHO "\nError: SNPSLMD_PATH variable not set. "
	$ECHO "\tUnable to locate FLEXlm/Synopsys executables."
	$ECHO "Would you like to enter the path now - Y/N [N] ? \c"
	read prmpt
	if [ "$prmpt" = "Y" ] || [ "$prmpt" = "y" ]; then
		$ECHO "FLEXlm Path: \c"
		read snps_path
		if [ ! -d $snps_path ]; then
			$ECHO "ERROR: $snps_path is invalid." \
				" Ignoring License Attributes"
			$ECHO "ERROR: $snps_path is invalid." \
				" Ignoring License Attributes" >> $logFile
		else
			$ECHO "SNPSLMD Version: " >> $logFile
			$snps_path/whatscl $snps_path/snpslmd >> $logFile
			$ECHO "\nFLEXlm Version: " >> $logFile
			$snps_path/lmutil lmver $snps_path/lmgrd >> $logFile
		fi
	else
		$ECHO "*** Ignoring License Attributes ***\n" >> $logFile
	fi
else
	snps_path=$SNPSLMD_PATH
	$ECHO "SNPSLMD Version: " >> $logFile
	$snps_path/whatscl $snps_path/snpslmd >> $logFile
	$ECHO "\nFLEXlm Version: " >> $logFile
	$snps_path/lmutil lmver $snps_path/lmgrd >> $logFile
fi

# collect complete system information
$ECHO "\nCollecting System information .. please wait \c"
getSysInfo >> $logFile 2>/dev/null

$ECHO "\nCollecting Environment \c"
$ECHO "\n\n================== Environment ======================" >> $logFile
cat /proc/$DAEMON_PID/environ >> $logFile 2>/dev/null

if [ $loopIntvl  -eq 0 ]; then
	$ECHO "\nCollecting Network statistics .. please wait \c"
else
	$ECHO "\nCollecting Network statistics every $loopIntvl seconds"
fi

$ECHO "\n======================================================" >> $logFile
$ECHO "================== System State ======================" >>   $logFile
$ECHO "======================================================" >>   $logFile
while true; do
	getDynInfo >> $logFile 2>/dev/null

	if [ ! -z "$CLIENT" ]; then
		getSockInfo >> $logFile 2>/dev/null
	fi

	if [ $loopIntvl  -eq 0 ]; then
		break
	fi
	$ECHO "\nHit Ctrl-C to stop ... \c"
	sleep $loopIntvl
done
exit 0
