#!/bin/sh

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -ne 3 ]
then

    usage [fastq] [seed len] [mismatch num in the seed]
fi

fchk $1


REF=/home/adminrig/Genome/maq_hq18/hg18.fasta
CWD=`pwd`
FILEDIR=`dirname $1`

# ReadFilter.sh $1 $2
# covert ill2sanger format
perl -MMin -nle'$h{length $_}++ if $.%4==0 }{ h1n(%h)' $1 > $1.ReadDist
ln -s $CWD/$1 $CWD/$1.ReadFilter
maq ill2sanger $1.ReadFilter $1.ReadFilter.sanger.fastq

# align
# -l : seed len
# -k : mismatch in seed len
bwa aln -l $2 -k $3 $REF $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai
#bwa aln -l $2 -k 3 $REF $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai
#bwa aln -l $2 -k 3 $REF $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai

# create sai
bwa samse $REF $1.ReadFilter.sanger.fastq.sai $1.ReadFilter.sanger.fastq > $1.ReadFilter.sanger.fastq.sai.sam

# convert from sam to bam
samtools view -bS -o $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam

# sort
samtools sort $1.ReadFilter.sanger.fastq.sai.sam.bam $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted

# pileup
samtools pileup -c -2 -f $REF $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam > $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup

# get in tile region
ViewerRegionInTile.pl -i $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup -t ~/Genome/RP/tile.span100 -s 0 -e 0 -c 1 -b 2 > $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile

# depth dist
perl -F'\t' -MMin -ane'$h{$F[7]}{$F[0]}++ }{ mmfsn("tile.depth.dist",%h)' $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile

perl -F'\t' -anle'@ARGV ? $h{$_}++ : $h{$F[1]}&& print' ~/Genome/pos $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile > $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile.real
perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1 if @F > 10' $1.ReadFilter.sanger.fastq.sai.sam > $1.ReadFilter.sanger.fastq.sai.sam.read
grep -v "*" $1.ReadFilter.sanger.fastq.sai.sam.read  > $1.ReadFilter.sanger.fastq.sai.sam.read.map
ComparePositionDetail -f $1.ReadFilter.sanger.fastq.sai.sam.read.map -s ~/Genome/RP/tile.span100 -1 1,2,3 -2 1,2,3 -a read -b tile

perl -F'\t' -MList::Util=sum -alne'@c{qw/A C G T/}=(0)x4;$F[8]=~s/[\$\^~]//g; @r=$F[8]=~/\w{1}/g; map{ $c{uc $_}++ } @r; print join "\t", @F[0..7],@c{qw/A C G T/},sum @c{qw/A C G T/} ' $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile > $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile.var
perl -F"\t" -MMin -anle'$h{ $F[-1] }++ }{ hist(%h)' $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile.var > $1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam.pileup.tile.var.hist


ViewerRegionInTile.pl -i $1.ReadFilter.sanger.fastq.sai.sam -t ~/Genome/RP/tile -s 100 -e 100 -c 3 -b 4 | perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1,$F[0],"set" if @F > 10' > $1.ReadFilter.sanger.fastq.sai.sam.FindCoveragePerDepth
FindCoveragePerDepth -i $1.ReadFilter.sanger.fastq.sai.sam.FindCoveragePerDepth -r ~/Genome/RP/tile
ComparePosition -f $1.ReadFilter.sanger.fastq.sai.sam.FindCoveragePerDepth -1 1,2,3 -s ~/Genome/RP/tile -2 1,2,3

if [ $FILEDIR != "." ]
then
	mv fir* sec.uniq.GFF  output.txt  tile.depth.dist.txt $FILEDIR
fi
