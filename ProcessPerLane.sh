#!/bin/sh

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -ne 4 ]
then

    usage [fastq.1] [fastq.2] [seed len] [mismatch num in the seed]
fi


PWD=$PWD
FILEDIR=`dirname $1`
OUTDIR=$PWD/$FILEDIR
FILENAME1=`basename $1`
FILENAME2=`basename $2`

REF=/home/adminrig/Genome/maq_hq18/hg18.fasta
TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed

fchk $1
fchk $2

# trim 
Trim.pl --type 2 --qual-type 1 --pair1 $1 --pair2 $2 --outpair1 $1.1 --outpair2 $1.2 --single $1.single > $1.trim.log


# ReadFilter.sh $1 $2
# covert ill2sanger format
perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1.1 > $1.1.ReadDist
perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1.2 > $1.2.ReadDist
perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1.2 > $1.single.ReadDist

ls $1.{1,2,single} | perl -nle'$_="$ENV{PWD}/$_"; `ln -s $_ $_.ReadFilter`'

maq ill2sanger $1.1.ReadFilter $1.1.ReadFilter.sanger.fastq
maq ill2sanger $1.2.ReadFilter $1.2.ReadFilter.sanger.fastq
maq ill2sanger $1.single.ReadFilter $1.single.ReadFilter.sanger.fastq

# align
# -l : seed len
# -k : mismatch in seed len

# create sai
bwa aln -l $3 -k $4 $REF $1.1.ReadFilter.sanger.fastq > $1.1.ReadFilter.sanger.fastq.sai
bwa aln -l $3 -k $4 $REF $1.2.ReadFilter.sanger.fastq > $1.2.ReadFilter.sanger.fastq.sai
bwa aln -l $3 -k $4 $REF $1.single.ReadFilter.sanger.fastq > $1.2.ReadFilter.sanger.fastq.sai

########
## PE ##
########
bwa sampe $REF $1.1.ReadFilter.sanger.fastq.sai $1.2.ReadFilter.sanger.fastq.sai $1.1.ReadFilter.sanger.fastq $1.2.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam
# convert from sam to bam
samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam
# sort
# samtools sort $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

########
## SE ##
########
bwa samse $REF $1.2.ReadFilter.sanger.fastq.sai $1.single.ReadFilter.sanger.fastq > $1.single.ReadFilter.sanger.fastq.sai.sam
# convert from sam to bam
samtools view -bS -o $1.single.ReadFilter.sanger.fastq.sai.sam.bam $1.single.ReadFilter.sanger.fastq.sai.sam
# sort
# samtools sort $1.single.ReadFilter.sanger.fastq.sai.sam.bam $1.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted


# merge SE and PE
samtools merge $1.bam $1.ReadFilter.sanger.fastq.sai.sam.bam $1.single.ReadFilter.sanger.fastq.sai.sam.bam

# sort bam
samtools sort $1.bam $1.bam.sorted

# indexing bam
samtools index $1.bam.sorted.bam

# pileup
samtools pileup -c -2 -f $REF $1.bam.sorted.bam > $1.bam.sorted.bam.pileup

# bam2sam
samtools view $1.bam.sorted.bam > $1.bam.sorted.sam

##############################################
# If this lane is conrol, add annotation '#' #
##############################################

# get in tile region
ViewerRegionInTile.pl -i $1.bam.sorted.bam.pileup -t $TILE -s 0 -e 0 -c 1 -b 2 > $1.bam.sorted.bam.pileup.tile

# depth dist
perl -F'\t' -MMin -ane'$h{$F[7]}{$F[0]}++ }{ mmfsn("tile.depth.dist",%h)'  $1.bam.sorted.bam.pileup.tile

 samtools view $1.bam.sorted.bam | perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1,$F[0],"set" if @F > 10' > $1.bam.sorted.bam.read
 grep -v "*"  $1.bam.sorted.bam.read >  $1.bam.sorted.bam.read.map
 ComparePositionDetail -f  $1.bam.sorted.bam.read.map -s $TILE -1 1,2,3 -2 1,2,3 -a read -b tile
 perl -F'\t' -MList::Util=sum -alne'@c{qw/A C G T/}=(0)x4;$F[8]=~s/[\$\^~]//g; @r=$F[8]=~/\w{1}/g; map{ $c{uc $_}++ } @r; print join "\t", @F[0..7],@c{qw/A C G T/},sum @c{qw/A C G T/} ' $1.bam.sorted.bam.pileup.tile > $1.bam.sorted.bam.pileup.tile.var
 perl -F"\t" -MMin -anle'$h{ $F[-1] }++ }{ hist(%h)' $1.bam.sorted.bam.pileup.tile.var > $1.bam.sorted.bam.pileup.tile.var.hist
 ViewerRegionInTile.pl -i $1.bam.sorted.sam -t $TILE -s 100 -e 100 -c 3 -b 4 | perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1,$F[0],"set" if @F > 10' > $1.bam.sorted.sam.FindCoveragePerDepth
 IsExistInRegion.pl --in-file $1.bam.sorted.bam.read.map --target-file $TILE
 FindCoveragePerDepth -i $1.bam.sorted.bam.read.map -r $TILE
 ComparePosition -f $1.bam.sorted.sam.FindCoveragePerDepth -1 1,2,3 -s $TILE -2 1,2,3

mkdir -p $OUTDIR/{PE,SE,ALL,TrimDist,Compare,Tile}
mv $1.bam* $OUTDIR/ALL
mv *.ReadDist $OUTDIR/TrimDist/
ls $1.* | grep -v single | xargs -i mv {} $OUTDIR/PE
ls $1.* | xargs -i mv {} $OUTDIR/SE
mv fir* sec.uniq.GFF $OUTDIR/Compare
mv out.txt tile.depth.dist.txt $OUTDIR/Tile


