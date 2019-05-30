#!/bin/sh
DIR=Report.`date +%Y%m%d`

GetTrimSeq.sh
GetCovPerDepth.sh
GetCoverageRange.sh
GetOnOffMappedBase.sh 

mkdir $DIR
mv OnOffMappedBase.txt CovPerDept.txt CoverageRange.txt trimmed.sequences.txt $DIR

