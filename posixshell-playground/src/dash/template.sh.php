#!/bin/sh

<?php
	$opts = array(
		"version:",
		"global-data:"
	);
	$var = getopt(Null,$opts);
?>

# M3TIOR 2017
#	Template file generator script:
#	the whole point of this script is to aid in my production
#	of projects. I hope this will help me and you reduce the amount of redundant
#	code we have to type or copy&paste from somewhere else. For the immediate
#	future I'm adding the abilty to template from files and strings. I may
#	add the ability to make templates of directories, but since my goal is
#	to use this shell's built-ins explicitly, I don't think that's going to be
#	entirely possible. Also, installing this script means you have to put up
#	with having a .templates folder put in your home directory for now.
#

template(){						#subshell forces pathname expansion, if needs full paths
	local SCRIPT_PATH;			SCRIPT_PATH=$(echo ${SCRIPT_PATH:-$PWD});
	local USER_PATH;			USER_PATH=$(echo ~/.templates/);
	local GLOBAL_PATH;			GLOBAL_PATH=<?php echo $var["global-data"]?>;
	local VERSION;				VERSION=<?php echo $var["version"]?>;
	local OPTARG; 				OPTARG='';
	local OPTIND; 				OPTIND=0;
	local IFS; 					IFS=' ';
	local TEMPLATE; 			TEMPLATE='';
	local VERBOSE;				VERBOSE=false;
	while getopts ":hvf:s:" arg; do
		case $arg in
			'f')
				TYPE='f';
				if [ -d "$SCRIPT_PATH" ] && [ -r "$SCRIPT_PATH/$OPTARG" ]; then
					TEMPLATE="$SCRIPT_PATH/$OPTARG";
				elif [ -d "$USER_PATH" ] && [ -r "$USER_PATH/$OPTARG" ]; then
					TEMPLATE="$USER_PATH/$OPTARG";
				elif [ -d "$GLOBAL_PATH" ] && [ -r "$GLOBAL_PATH/$OPTARG" ]; then
					TEMPLATE="$GLOBAL_PATH/$OPTARG";
				elif [ -r "$OPTARG" ]; then
					TEMPLATE="$OPTARG";
				else
					echo "Error: template $OPTARG file not found!";
					exit 1;
				fi;
			;;
			's')
				TYPE='s';
				TEMPLATE="$OPTARG";
			;;
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
	shift $(($OPTIND-1));
	for file in "$@"; do
		if [ -s "$file" ]; then
			echo "Cannot create '$file': File already exists!";
			exit 1;
		fi;
	done;
	if [ "$TYPE" != "s" ]; then
		for file in "$@"; do
			while read line; do echo "$line" >> $file; done < $TEMPLATE;
			if $VERBOSE; then echo "Created $FILE from template: $TEMPLATE"; fi;
		done;
	elif [ "$TYPE" != "f" ]; then
		for file in "$@"; do
			printf "$TEMPLATE" >> $file;
			if $VERBOSE; then echo "Created $FILE from template: $TEMPLATE"; fi;
		done;
	fi;
}

if [ "${0##*/}" != "template.sh" ] && [ "${0##*/}" != "template" ]; then
	echo "Successfully imported 'template'!" >&2;
else
	template $@;
	exit $?
fi;
