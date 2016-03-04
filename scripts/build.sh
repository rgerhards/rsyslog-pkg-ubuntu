#!/bin/bash
# Definitions common to these scripts
source $(dirname "$0")/config.sh

TARGZFILES=`ls *.dsc`

echo "-------------------------------------"
echo "--- RPMMaker                      ---"
echo "-------------------------------------"

echo "Select DSC Filebasename:"
select szDscFile in $TARGZFILES
do
	break;
done

echo "Select Ubuntu DIST:"
select szPlatform in $PLATFORM
do
        break;
done

echo "Select CPU Platform:"
select szArch in $ARCHTECT "All"
do
	case $szArch in "All")
		szArch=$ARCHTECT;
	esac
        break;
done

echo "Select RSyslog BRANCH:"
select szBranch in $BRANCHES
do
	echo "Making Packages for '$szDscFile' ($szBranch) on '$szPlatform'/'$szArch' "
	break;
done

# Loop through architects
for szArchitect in $szArch;
do
	szAddArch="";
	if [ $szArchitect = "i386" ]; then
		szAddArch="-i386";
	fi

	# Set Basename!
	szDscFileBase=`basename $szDscFile .dsc`

	#echo "$szDscFile $szDscFileBase";
	#exit;

	#pbuilder-dist $szBranch create
	APPENDSUFFIX="_$szArchitect.changes"
	pbuilder-dist $szPlatform $szArchitect build $szDscFile 
	#dput $szBranch ../pbuilder/$szPlatform$szAddArch\_result/$szDscFileBase$APPENDSUFFIX
done;
