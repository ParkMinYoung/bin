#!/bin/sh
find -type f | egrep "(pileup(.AlleleCnt|.tile)?|bam.read.map)"$ | sort
