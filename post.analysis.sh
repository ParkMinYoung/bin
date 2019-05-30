#!/bin/sh 
GetCovPerDepth.sh
GetTrimSeq.sh
GetCoverageRange.sh
GetOnOffMappedBase.sh

DATE=`date +%F`
mkdir post.analysis.$DATE
mv CoverageRange.txt CovPerDept.txt OnOffMappedBase.txt trimmed.sequences.txt post.analysis.$DATE

