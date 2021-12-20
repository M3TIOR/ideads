#!/bin/bash
#!/usr/bin/bash

#
# M3TIOR 2018: import lib;
#

import(){
	# TODO:
	#	[] Add Dependency Warnings for CURL
	#	[] Add ###@IMPORT:location### Flag Support
	#	[] Add Ignore Volatile Option
	#	[] Add Direct Update method
	#	[] Add Buffered Update method
	#	[] Add
	#
	local VERSION;				VERSION="0.1";
	local OPTARG; 				OPTARG='';
	local OPTIND; 				OPTIND=0;
	local IFS; 					IFS=' ';
	local VERBOSE;				VERBOSE=false;
	local TARGET_FILE;			TARGET_FILE="";
	while getopts ":hv" arg; do
		case $arg in
			'f')
				TARGET_FILE=$OPTARG;
			;;
			'n')
			'i')
			'v') VERBOSE=true;;
			'h')
				echo "Usage: $0 -hv [[-f FILE] or [-s STRING]] FILES..."
				echo "\t-f\tUses FILE as a template for FILES.";
				echo "\t-s\tUses STRING as a template for FILES.";\
				echo "\t-v\t'Verbose' makes this script print all outputted files when completed.";
				echo "\t-h\tPrint's this message.";
				echo "";
				echo "NOTE: the -f and -s parameters override each other.";
				return 0;
			;;
			[?])
				echo "Usage: $0 -hv [-f FILE] [-s STRING] FILES..." >&2;
				exit 1;
			;;
		esac;
	done;

	if [ -e $TARGET_FILE]

}

if [ "${0##*/}" != "import.sh" ] && [ "${0##*/}" != "import" ]; then
	echo "Successfully included 'import'!" >&2;
else
	template $@;
	exit $?
fi;
