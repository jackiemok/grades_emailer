#!/bin/bash

EMAIL_BODIES=$(pwd)'/histMath_grade_emails/*.txt'
dos2unix --quiet $EMAIL_BODIES

for file in $EMAIL_BODIES
do
	BASEFILE=$(basename $file '.txt')
	SUBJECT='History of Mathematics Grades'
	TO_VAL=$BASEFILE'@tufts.edu'
	CC_VAL='*****@tufts.edu'
	cat $file | mailx -s "$SUBJECT" -c "$CC_VAL" $TO_VAL
done
