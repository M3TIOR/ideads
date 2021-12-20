#!/bin/sh

#### GENERATED TEMPLATE:
#
#

# CREATOR MM/DD/YYYY
#
#	NOTE: comments about script
#

main(){
	local IFS;		IFS=' '; 	# Store local IFS in scripts you wish to be unaffected by the prior
	local OPTARG;	OPTARG=''; 	# Store local OPTARG to prevent unintended side effects of using externals
	local OPTIND;	OPTIND=0;	# Same as OPTARG
	while getopts ":h" arg; do
		case $arg in
			'h')
				echo "Usage: $0 -h ARGS...";
				return 0;
			;;
			[?]) #UNRECOGINZED ARGUMENT
				echo "Usage: $0 -h ARGS..." >&2;
				exit 1;
			;;
		esac;
	done;
	#OTHER CODE GOES HERE
}
main $@; exit $?;
