#!/bin/sh

## trim

#find s_?/ -type f | grep fastq$ | sort | xargs -n 2 echo | perl -F'\s+' -anle'print "qsub -N trim ~/src/short_read_assembly/bin/sub Trim.pl --type 2 --qual-type 1 --pair1 $F[0] --pair2 $F[1] --outpair1 $F[0].trimed --outpair2 $F[1].trimed --single $F[0].single\nsleep 20"' > trim.sh

#find s_?/ -type f | grep fastq$ | sort | xargs -n 2 echo | perl -F'\s+' -anle'print "Trim.pl --type 2 --qual-type 1 --pair1 $F[0] --pair2 $F[1] --outpair1 $F[0].trimed --outpair2 $F[1].trimed --single $F[0].single >& /dev/null &"' > trim.sh
#sh trim.sh

## wait
#perl -le'while($l=`top -b -n 1`){ $l=~/Trim\.pl/ ? sleep 10 : exit }'

## symbolic link
find s_? | grep trimed$ | perl -nle's/\.\///;$_=$ENV{PWD}."/".$_; $c=$_;s/\.fastq\.trimed//;print "$_\t$c";`ln -s $c $_`'
find . -type f | grep single$ | xargs -i dirname {} | xargs -i mkdir -p {}/single
find s_? -type f -name "*single" | perl -MFile::Basename -nle'$_=$ENV{PWD}."/".$_;($f,$d)=fileparse $_;`ln -s $_ $d/single`'

## paired end mapping
find s_? -maxdepth 2 | perl -nle'if(s/\.[12]$//){$h{$_}++} }{ map {/(s_\d)/;print "qsub -N PE$1 ~/src/short_read_assembly/bin/sub bwa.auto.PairedEndV2.S32M2Hg19.sh $_ 32 2\nsleep 20" } sort keys %h'  > PE.sh
sh PE.sh

## single end mapping
find s_? | grep "single/" | perl -nle'/(s_\d)/; print "qsub -N SE$1 ~/src/short_read_assembly/bin/sub bwa.auto.SingleEndV2.S32M2Hg19.sh $_ 32 2\nsleep 20" ' > SE.sh
sh SE.sh

perl -le'print localtime()."Wait......";while($l=`qstat -u adminrig`){ $l=~/[SP]E/ ? sleep 10 : print localtime()." " & exit}'
rm -rf s_?.{s,e,o}*



mkdir Group
samtools merge Group/s_1.bam ./s_1/s_1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_1/single/s_1.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_2/s_2.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_2/single/s_2.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_2.bam ./s_3/s_3.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_3/single/s_3.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_4/s_4.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_4/single/s_4.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_4.bam ./s_7/s_7.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_7/single/s_7.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_8/s_8.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_8/single/s_8.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_3.bam ./s_5/s_5.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_5/single/s_5.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_6/s_6.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_6/single/s_6.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam

cd Group
MkDIR.MV.sh
Bam2Tile.TrimedFastq.sh s_1/s_1 >& s_1.log &
Bam2Tile.TrimedFastq.sh s_2/s_2 >& s_2.log &
Bam2Tile.TrimedFastq.sh s_3/s_3 >& s_3.log &
Bam2Tile.TrimedFastq.sh s_4/s_4 >& s_4.log &



