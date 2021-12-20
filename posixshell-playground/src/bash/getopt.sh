#!/bin/bash
#!/usr/bin/bash

#
# M3TIOR 2018: getopt bash mimic;
#

getopt(){
	#NOTE:
	#	Ok, so I know this looks really dumb, having a double assignment;
	#		A="foo";	-->		declare -xyz A="bar";
	#
	#	But this is tricky, because I'm not just assigning a value to A.
	#	Instead, what I've just done is make a variable with the default
	#	bash scope, before calling declare to isolate it's behavior.
	#
	#	You see, due to the way bash is implemented, there are three different.
	#	targetable scopes.
	#		 global				- declare -g VAR="XYZ"
	#		 local				- ( local VAR="XYZ" ) or ( declare VAR="XYZ" )
	#	and	 default / auto		- VAR="XYZ"
	#
	#	In the bash source code, every session; either interactive or scripted,
	#	has a global hash list, this is the global scope. The way the local
	#	scope is created, is by attatching a temporary hash list to each of the
	#	session's function's instances. What I'm calling the "default" scope,
	#	is the process by which bash finds a place to put the variable which
	#	we've just declared when not explicitely stated.
	#		ie:
	#			explicit	[ declare -g A; ] or [ local A; ]
	#			inexplicit	[ A=""; ]
	#
	#	The default scope works by propogating backwards down the 'stack'
	#	or, rather each subsequently called function's temporary hash list in
	#	memory, and attatches our new value to the topmost matching assignment,
	#	or to the global scope when it doesn't find one.
	#
	#	So this double assignment allows callers of this function to declare
	#	local variables for containing our values, and thus nest getopt
	#	instances just as you would the bash getopts built-in.
	#
	#
	OPTIND=$OPTIND;				declare -i OPTIND=$OPTIND;
	OPTERR=1;					declare -i OPTERR=1;
	OPTARG=$OPTARG;				OPTARG='';
	local IFS; 					IFS=' ';
	local LONG;					LONG='';
	local SHORT;				SHORT='';
	local FLAGS;				declare -a FLAGS;
	for flag in $(# USING SUBSHELL
		# we have to use getopts for argument parsing, so that means we also
		# have to limit it's access to our OPTARG, OPTIND, and OPTERR
		# environment variables, otherwise they'll be corrupted when passed to
		# the end user.
		set -- $*; # make our arguments available to enclosed getopts
		declare -a flags; # make an array for containing out argument flags
		flags=(0 1 "" "" "" 1 1 "" 1 1 1 1 ""); # initalized default values
		while getopts ":alnopQsTuhV" arg; do
			case $arg in
				'F') flags[0]=$OPTIND;;
				'a') flags[1]=0;;
				'l') flags[2]="$OPTARG";;
				'n') flags[3]="$OPTARG";;
				'o') flags[4]="$OPTARG";;
				'q') flags[5]=0;;
				'Q') flags[6]=0;;
				's') flags[7]="$OPTARG";;
				'T') flags[8]=0;;
				'u') flags[9]=0;;
				'h') flags[10]=0;;
				'V') flags[11]=0;;
				[?]) flags[12]="$OPTARG"; exit 1;;
			esac;
		done;
		for flag in ${flags[*]}; do
			printf "\"%s\"" "$flag";
		done;
	); do FLAGS+=( $flag ); done; # externalize flags
	echo "$?";
	echo ${FLAGS[10]}
	if [ $? -ne 0 ]; then
		echo "getopt: unrecognized option \"${FLAGS[12]}\"";
		echo 'Try `getopt -h for more information`';
		return 2;
	fi;
	if (( "${FLAGS[10]}" > 0 )); then
		while read line; do echo "$line"; done; <<- HELP
		Usage:
		 getopt <optstring> <parameters>
		 getopt [options] <optstring> <parameters>>

		Parse command options.

		Options:
		 -a 				allow long options starting with single -
		 -F 				force use of script getopt over native
		 -l <longopts>		the long options to be recognized
		 -n <progname>		the name under which errors are reported
		 -o <optstring>		the short options to be recognized
		 -q 				disable error reporting by getopt(3)
		 -Q 				no normal output
		 -s <shell>			set quoting conventions to those of <shell>
		 -T 				test for getopt(1) version
		 -u 				do not quote the output

		 -h 				display this help and exit
		 -V 				output version information and exit

		For more details see getopt(4).
		HELP
	fi;
	local NATIVE=$( builtin type -fp getopt );
	if [ $? -ne 0 ] && [ ${FLAGS[0]} -gt 0 ]; then
		$NATIVE $*;
	else
		echo;
	fi;

}

if [ "${0##*/}" != "getopt.sh" ] && [ "${0##*/}" != "getopt" ]; then
	echo "Successfully included 'getopt'!" >&2;
else
	getopt $@;
	exit $?
fi;
