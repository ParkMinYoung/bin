#!/bin/sh

perl -F'\t' -anle'if(@ARGV){
      $h{$F[9]}=$F[2]}
else{ 
      /(\d+$)/;
      $sample=$h{$1};
      print "tar cvzf $sample.tgz `find $_ | grep sorted`"
}' SamplesDirectories.txt dir.list > tgz.batch.sh 

