#!/bin/sh

DIR=$1/Data/Intensities
OUT=$1.`date +%Y%m%d`

rm -rf $OUT.tmp
find $1 -maxdepth 2 | egrep "(InterOp|RunInfo.xml)" > $OUT.tmp
find $DIR -maxdepth 1 | egrep "pos.txt|xml" | sort >> $OUT.tmp
find $DIR/Offsets/ | sort >> $OUT.tmp
find $DIR/BaseCalls/{L00?,Matrix,Phasing} | sort >> $OUT.tmp
find $DIR/BaseCalls/ -maxdepth 1 -type f | egrep "(filter|xml|xsl)$" | sort >> $OUT.tmp

#tar cvjf $OUT.RunInfo.bz2 $1/InterOp/* $1/RunInfo.xml
#tar cvjf $OUT.bz2 --files-from $OUT.tmp > $OUT.bz2.log 2>&1

cat $OUT.tmp | xargs -i -n 100 cp -av {} --target-directory=/home/adminrig/SolexaData/nas/ --parents >& $OUT.log 

MakeSolexaRunBackup.cp.check.sh nas/$1 > $OUT.cp.check.log
#egrep "s_[1-4]|L00[1-4]|config|xml$|xsl$" 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.tmp > 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic

#tar cvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.KOBIC.Lane1-4.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic >&101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101020.Kobic.log &

#tar xvjf 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2 --files-from 101015_ILLUMINA-CD89F7_00002_FC_NEW02.20101025.bz2.list.Lane56 -C ../Lane56

# cp -av `find 2010* | grep bz2$` --target-directory=tmp/ --parents
