#!/bin/sh


source ~/.bash_function

if [ -d "$1" ];then

DIR=$1/Data/Intensities
OUT=/home/adminrig/SolexaData/Sequence.backup/$1.`date +%Y%m%d`

rm -rf $OUT.tmp
find $DIR -maxdepth 1 | egrep "pos.txt|xml" | sort >> $OUT.tmp
find $DIR/Offsets/ | sort >> $OUT.tmp
find $DIR/BaseCalls/{L00?,Matrix,Phasing} | sort >> $OUT.tmp
find $DIR/BaseCalls/ -maxdepth 1 -type f | egrep "(filter|xml|xsl)$" | sort >> $OUT.tmp

tar cvjf $OUT.RunInfo.bz2 $1/InterOp/* $1/RunInfo.xml
tar cvjf $OUT.bz2 --files-from $OUT.tmp > $OUT.bz2.log 2>&1

#egrep "s_[1-4]|L00[1-4]|config|xml$|xsl$" 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.tmp > 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic

#tar cvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.KOBIC.Lane1-4.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic >&101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic.log &

#tar xvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2.list.Lane56 -C ../Lane56

# cp -av `find 2010* | grep bz2$` --target-directory=tmp/ --parents

else
	usage "101015_ILLUMINA-CD89F7_00002_FC_NEW02"
fi

