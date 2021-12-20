OPTARG=$OPTARG;				declare OPTARG;
OPTIND=$OPTIND;				declare -i OPTIND=$OPTIND;
OPTERR=1;					declare -i OPTERR=1;
IFS=' ';
LONG='';
SHORT='';
set -- $*; # make our arguments available to enclosed getopts
declare -a flags; # make an array for containing out argument flags
flags=(0 1 '' '' '' 1 1 '' 1 1 1 1 ''); # initalized default values
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
echo "${flags[*]}";
