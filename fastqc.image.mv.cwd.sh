#!/bin/sh

DIR=$PWD/../
SEQ=RawSeqAnalaysis

DEST=$DIR/$SEQ

if [ ! -d $DEST ];then
	mkdir -p $DEST
fi


find Project_KNIH.set* -type f | grep png$ | grep Images |
perl -MFile::Basename -snle'
($f,$d)=fileparse($_);
$d=~/(set\d+)\/Sample_.+\/(.+)_(\w{6})_(L00\d)_(R\d)/;
($set,$id,$idx,$l,$r)=($1,$2,$3,$4,$5);
$f=~s/\.$ext//;
#print "$set $id $idx $l $r $f";
$dir="$dest/$f";
mkdir $dir if ! -d $dir;
`cp -f $_ $dir/$set.$id.$r.$idx.$l.$ext`;
' -- -dest=$DEST -ext="png"

find Project_KNIH.set* -type d | grep fastqc$ | 
perl -MFile::Basename -snle'
$d=$_;
$d=~/(set\d+)\/Sample_.+\/(.+)_(\w{6})_(L00\d)_(R\d)/;
($set,$id,$idx,$l,$r)=($1,$2,$3,$4,$5);

$dir="$dest/$summary";
mkdir $dir if ! -d $dir;
`cp -f $_/summary.txt $dir/$set.$id.$r.$idx.$l.txt`;

$dir="$dest/$data";
mkdir $dir if ! -d $dir;
`cp -f $_/fastqc_data.txt $dir/$set.$id.$r.$idx.$l.txt`;

' -- -dest=$DEST -summary="summary" -data="fastqc_data"


# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_base_quality.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/sequence_length_distribution.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_base_n_content.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_base_sequence_content.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_sequence_quality.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_sequence_gc_content.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/kmer_profiles.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/duplication_levels.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R2_001_fastqc/Images/per_base_gc_content.png
# Project_KNIH.set1/Sample_VP04173/VP04173_GCCAAT_L001_R1_001_fastqc/Images/per_base_quality.png
