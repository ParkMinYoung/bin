#!/bin/sh -x

# sh $0 /home/adminrig/SolexaData/100525_HWUSI-EAS052R_0006_SURE2/Data/Intensities/BaseCalls/Sequence/s_5 /home/adminrig/SolexaData/100525_HWUSI-EAS052R_0006_SURE2/Data/Intensities/BaseCalls/Sequence/s_5/s_5.1

# $1 = /home/adminrig/SolexaData/100525_HWUSI-EAS052R_0006_SURE2/Data/Intensities/BaseCalls/Sequence/s_5
# $2 = /home/adminrig/SolexaData/100525_HWUSI-EAS052R_0006_SURE2/Data/Intensities/BaseCalls/Sequence/s_5/s_5.1

TmpDIR=$1
Input=$2

for i in `find $TmpDIR | grep RiboRead$`; do perl -nle' if($ARGV=~/RiboRead/){@F=split "\t";$h{$F[0]}++} else{$c++;push @l,$_;  if($c%4==0){$c_l=$l[0]; $l[0]=~s/(^\@|\/\d)//g; if( !$h{$l[0]} ){ $l[0]=$c_l;print join "\n",@l };   @l=() }}' `find $TmpDIR | grep RiboRead$` $Input > $Input.RiboCleanup; done



