#!/bin/sh

#### GENERATED TEMPLATE:
#	the term 'main' in this file is intended to be used as a refference to
#	the 'main' linked binary in executables. Used in shell, this format
#	is intended to make scripts behave more like native applications.
#	the import availablity at the bottom is for dynamically loading chunks of
#	a larger script as an optimization method.
#

# CREATOR YYYY
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
				echo "Usage: $0 -h ARGS..."
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

if [ "${0##*/}" != "main.sh" ] && [ "${0##*/}" != "main" ]; then
	echo "Successfully imported 'template'!" >&2;
else
	main $@;
	exit $?
fi;
