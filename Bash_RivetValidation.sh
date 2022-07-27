#!/bin/bash
(
echo "******************************************************************"
echo "Rivet validation script"
echo ""
ls -l
echo ""
echo $ALIEN_PACKAGES
echo $ALIEN_JDL_PACKAGES
echo "******************************************************************"
) >> stdout

if [ -s "Rivet.yoda" ]; then
	exit 0
else
	echo "Output file \"Rivet.yoda\" doesn't exist or is of 0 size" >> stderr
	exit 1
fi
