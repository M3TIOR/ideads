#!/bin/sh

<?php
	$opts = array(
		"git-version:",
		"git-pubdate:",
		"git-license:"
	);
	$var = getopt(Null,$opts);
?>

#
# M3TIOR 2018: m3sh wrapper;
#	MESH is a shell wrapper meant to give programmers and standard
#	users access to alternative shell scripts and syntax without the
#	opening up a separate shell instance. Instead, use mesh, which provides
#	script unification and a package manager.
#
#
# EXIT CODES:
#	3 - not an sourcable/includable module, and was sourced
#

# COMPILE TIME VARIABLES
local VERSION;			VERSION="<?php echo $var["git-version"]?>";
local PUBDATE;			PUBDATE="<?php echo $var["git-pubdate"]?>";
local LICENSE;			LICENSE="<?php echo $var["git-license"]?>";


if [ "${0##*/}" == "m3sh.sh" ] && [ "${0##*/}" == "m3sh" ]; then
	echo "";
else
	exit 3
fi;
