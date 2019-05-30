#!/bin/sh -x

#  $1 : fastq file
#  $2 : seed length
#  $3 : mismatch num

source $HOME/.bash_function

if [ $# -ne 1 ]
then

    usage [s_?]
fi

# YS1/YS1
# s_1/s_1

PWD=$PWD
FILEDIR=`dirname $1`
OUTDIR=$PWD/$FILEDIR

REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta
#TILE=~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed
TILE=~/Genome/Nimblegen/2.1M_Human_Exome.hg19.bed
GENOME=/home/adminrig/Genome/hg19Fasta/hg19.genome


# mapping quality QC 10 and perform sorting
samtools view -ub -q 10 $1.bam | samtools sort - $1.bam.sorted


# indexing bam
samtools index $1.bam.sorted.bam

# pileup
samtools pileup -c -2 -f $REF $1.bam.sorted.bam > $1.bam.sorted.bam.pileup
PID=`perl -e'print "N$$"'`
#qsub -N $PID ~/src/short_read_assembly/bin/sub PileupParsing.pl --in-file $1.bam.sorted.bam.pileup --target-file  ~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed --quality-score 34 --out-file $1.bam.sorted.bam.pileup.AlleleCnt
ssh solexa01 qsub -N $PID -o $PWD/$PID.o -e $PWD/$PID.e ~/src/short_read_assembly/bin/sub PileupParsing.noTarget.pl --in-file $PWD/$1.bam.sorted.bam.pileup --target-file $TILE --quality-score 34 --out-file $PWD/$1.bam.sorted.bam.pileup.AlleleCnt

# bam2sam
#!# samtools view $1.bam.sorted.bam > $1.bam.sorted.sam

##############################################
# If this lane is conrol, add annotation '#' #
##############################################

# get in tile region
ViewerRegionInTile.pl -i $1.bam.sorted.bam.pileup -t $TILE -s 0 -e 0 -c 1 -b 2 > $1.bam.sorted.bam.pileup.tile

# depth dist
perl -F'\t' -MMin -ane'$h{$F[7]}{$F[0]}++ }{ mmfsn("tile.depth.dist",%h)'  $1.bam.sorted.bam.pileup.tile

### old ###
# samtools view $1.bam.sorted.bam | perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1,$F[0],"set" if @F > 10' > $1.bam.sorted.bam.read
# grep -v "*"  $1.bam.sorted.bam.read | cut -f1-3 >  $1.bam.sorted.bam.read.map
### new ###
## samtools view $1.bam.sorted.bam | awk 'BEGIN{OFS="\t"}{print $3,$4,$4+length($10)-1} | grep -v "*" > $1.bam.sorted.bam.read.map
bamToBed -i $1.bam.sorted.bam -split | cut -f1-3 > $1.bam.sorted.bam.read.map

#ComparePositionDetail -f  $1.bam.sorted.bam.read.map -s $TILE -1 1,2,3 -2 1,2,3 -a read -b tile
 perl -F'\t' -MList::Util=sum -alne'@c{qw/A C G T/}=(0)x4;$F[8]=~s/[\$\^~]//g; @r=$F[8]=~/\w{1}/g; map{ $c{uc $_}++ } @r; print join "\t", @F[0..7],@c{qw/A C G T/},sum @c{qw/A C G T/} ' $1.bam.sorted.bam.pileup.tile > $1.bam.sorted.bam.pileup.tile.var
 perl -F"\t" -MMin -anle'$h{ $F[-1] }++ }{ hist(%h)' $1.bam.sorted.bam.pileup.tile.var > $1.bam.sorted.bam.pileup.tile.var.hist
# ViewerRegionInTile.pl -i $1.bam.sorted.sam -t $TILE -s 100 -e 100 -c 3 -b 4 | perl -F'\t' -anle'print join "\t", $F[2],$F[3],$F[3]+length($F[9])-1,$F[0],"set" if @F > 10' > $1.bam.sorted.sam.FindCoveragePerDepth
 #IsExistInRegion.pl --in-file $1.bam.sorted.bam.read.map --target-file $TILE
 #FindCoveragePerDepth -i $1.bam.sorted.bam.read.map -r $TILE
 #ComparePosition -f $1.bam.sorted.sam.FindCoveragePerDepth -1 1,2,3 -s $TILE -2 1,2,3
# get sequencing region 


mergeBed -i $1.bam.sorted.bam.read.map > $1.bam.sorted.bam.read.map.SeqRegion
mergeBed -i $TILE > $1.Target.bed.SeqRegion
perl -F'\t' -MMin -anle'$h{$F[0]}+=$F[2]-$F[1]+1;$h{Total}+=$F[2]-$F[1]+1}{ h1c(%h)' $1.Target.bed.SeqRegion > $1.Target.bed.SeqRegion.Len
perl -F'\t' -MMin -anle'$h{$F[0]}+=$F[2]-$F[1]+1;$h{Total}+=$F[2]-$F[1]+1}{ h1c(%h)' $1.bam.sorted.bam.read.map.SeqRegion > $1.bam.sorted.bam.read.map.SeqRegion.Len

# get intersect between sequencing region and design
intersectBed -a $1.bam.sorted.bam.read.map.SeqRegion -b $1.Target.bed.SeqRegion > $1.bam.sorted.bam.read.map.SeqRegion.intersect

ln -s $1.bam.sorted.bam.read.map.SeqRegion Seq
ln -s $1.Target.bed.SeqRegion Target
ln -s $1.bam.sorted.bam.read.map.SeqRegion.intersect Intersect 

perl -F'\t' -MMin -asne'chomp(@F);$h{$F[0]}{$ARGV}+=$F[2]-$F[1]+1; $chr{$F[0]}++ }{ for (keys %chr) { next if !$h{$_}{Target}; next if !$h{$_}{Seq}; $h{$_}{TargetEff}=sprintf "%2.2f",$h{$_}{Intersect}/$h{$_}{Target}*100; $h{$_}{SeqEff}=sprintf "%2.2f",$h{$_}{Intersect}/$h{$_}{Seq}*100 } ;mmfss("$out.bam.sorted.bam.read.map.SeqRegion.intersect",%h)' -- -out=$1 Seq Target Intersect

rm -rf Seq Target Intersect

#======================#
# get in target region #
#======================#
# get reads in target region
# intersectBed -a $1.bam.sorted.bam.read.map -b $TILE -wa > $1.bam.sorted.bam.read.map.In(bug no use -u)
#intersectBed -a $1.bam.sorted.bam.read.map -b $TILE -wa -u > $1.bam.sorted.bam.read.map.In
# get reads in target region, but exact parts
# intersectBed -a $1.bam.sorted.bam.read.map -b $TILE > $1.bam.sorted.bam.read.map.ExactlyIn(bug no use -u)
#intersectBed -a $1.bam.sorted.bam.read.map -b $TILE -u > $1.bam.sorted.bam.read.map.ExactlyIn
#mergeBed -i $1.bam.sorted.bam.read.map.ExactlyIn > $1.bam.sorted.bam.read.map.ExactlyIn.merged
intersectBed -abam $1.bam.sorted.bam -b $1.Target.bed.SeqRegion -bed -split > $1.bam.sorted.bam.read.map.ExactlyIn

## Inserted 20101126 ##
# mapping quality QC 0 and perform sorting
samtools view -ub $1.bam | samtools sort - $1.bam.NoMQ.sorted
# Intersect region
intersectBed -abam $1.bam.NoMQ.sorted.bam -b $1.Target.bed.SeqRegion -bed -split > $1.bam.NoMQ.sorted.bam.read.map.ExactlyIn
rm -rf $1.bam.NoMQ.sorted.bam
## Inserted 20101126 ##



mergeBed -i $1.bam.sorted.bam.read.map.ExactlyIn > $1.bam.sorted.bam.read.map.ExactlyIn.merged
perl -F'\t' -MMin -anle'$h{$F[0]}+=$F[2]-$F[1]+1;$h{Total}+=$F[2]-$F[1]+1}{ h1c(%h)' $1.bam.sorted.bam.read.map.ExactlyIn.merged > $1.bam.sorted.bam.read.map.ExactlyIn.merged.Len

#======================#
# coverage             #
#======================#
# get target region coverage 
coverageBed -a $1.bam.sorted.bam.read.map -b $TILE > $1.bam.sorted.bam.read.map.coverage


## get genome Coverage all reads
genomeCoverageBed -i $1.bam.sorted.bam.read.map -g $GENOME > $1.bam.sorted.bam.read.map.depth
## get genome Coverage reads in target region
genomeCoverageBed -i $1.bam.sorted.bam.read.map.In -g  $GENOME > $1.bam.sorted.bam.read.map.In.depth
## get genome Coverage reads in exact target region
genomeCoverageBed -i $1.bam.sorted.bam.read.map.ExactlyIn -g  $GENOME > $1.bam.sorted.bam.read.map.ExactlyIn.depth
## get Depth VS Coverage
perl -F'\t' -MMin -MList::Util=sum,max -anse'BEGIN{%h=h($f,1,2)} if( $F[1] && $F[0]=~/chr/){ $c{$F[0]}{$F[1]}=$F[2]; $c{Total}{$F[1]}+=$F[2] }  }{ for $chr ( keys %c ){ %tmp=%{$c{$chr}}; @dep = sort {$a<=>$b}keys %tmp; @c=@dep; $max=max @c;for $d ( 1..$max ){ shift @c; $c{$chr}{$d} += sum @tmp{@c}; $o{$chr}{$d}= sprintf "%2.2f", $c{$chr}{$d}/$h{$chr}*100; } } ; %oo=h2r(%o); %oc=h2r(%c); mmfsn("$out.bam.sorted.bam.read.map.ExactlyIn.DepthVsCov",%oo); mmfsn("$out.bam.sorted.bam.read.map.ExactlyIn.DepthVsCov.count",%oc)' -- -f=$1.Target.bed.SeqRegion.Len -out=$1 $1.bam.sorted.bam.read.map.ExactlyIn.depth

perl -sle'while($l=`qstat -u adminrig`){ $l=~/$pid/ ? sleep 10 : print localtime()." " & exit}' -- -pid=$PID

#PileupParsing.pl --in-file $1.bam.sorted.bam.pileup --target-file $TILE --quality-score 34 --out-file $1.bam.sorted.bam.pileup.AlleleCnt

#=====no use======#
#perl -F"\t" -anle'print join "\t", $F[0], $F[1]-1, $F[1]' $1.bam.sorted.bam.pileup.AlleleCnt > $1.bam.sorted.bam.pileup.AlleleCnt.All.bed
#mergeBed -i $1.bam.sorted.bam.pileup.AlleleCnt.All.bed > $1.bam.sorted.bam.pileup.AlleleCnt.All.bed.merged
#perl -F'\t' -MMin -anle'$h{$F[0]}+=$F[2]-$F[1]+1;$h{Total}+=$F[2]-$F[1]+1}{ h1c(%h)' $1.bam.sorted.bam.pileup.AlleleCnt.All.bed.merged > $1.bam.sorted.bam.pileup.AlleleCnt.All.bed.merged.Len

AlleleCnt2bed.pl --in-file $1.bam.sorted.bam.pileup.AlleleCnt
RegionCount.sh $1.bam.sorted.bam.pileup.AlleleCnt.var.bed > $1.bam.sorted.bam.pileup.AlleleCnt.var.bed.RegionCount.log


## Get bed file to convert hg18 to hg19
#perl -F'\t' -asnle'next unless $F[21] eq "-"; next if $F[2]=~/[Nn]/; $F[2]=uc $F[2]; @A{qw/A C G T/}=@F[4..7]; @a{qw/A C G T/}=@F[13..16]; $T= delete $a{$F[2]}; @l=sort {$a{$b} <=> $a{$a}} keys %a; $r=sprintf "%0.4f",$a{$l[0]}/$F[19]; if($F[19]>=$Tdep && $r >= $Rate){print join "\t", @F[0],$F[1]-1,$F[1],"1;$F[2]/$l[0];$F[10]/$A{$l[0]};$F[19]/$a{$l[0]};$r;$F[0];@{[$F[1]-1]};$F[1]" }' -- -Tdep=30 -Rate=0.3 $1.bam.sorted.bam.pileup.AlleleCnt.var > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed

perl -F'\t' -asnle'next if $F[2]=~/[Nn]/;$F[2]=uc $F[2]; @A{qw/A C G T/}=@F[4..7]; @a{qw/A C G T/}=@F[13..16]; $T= delete $a{$F[2]}; @l=sort {$a{$b} <=> $a{$a}} keys %a;$r= sprintf "%0.4f",$a{$l[0]}/$F[19]; if($F[19]>=$Tdep && $r >= $Rate){print join "\t", @F[0],$F[1]-1,$F[1],"1;$F[2]/$l[0];$F[10]/$A{$l[0]};$F[19]/$a{$l[0]};$r;$F[0];@{[$F[1]-1]};$F[1]"}' -- -Tdep=30 -Rate=0.3 $1.bam.sorted.bam.pileup.AlleleCnt.var > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed

perl -snle'next if /-$/;@F=split "\t";next if $F[2]=~/[Nn]/; $F[2]=uc $F[2]; @A{qw/A C G T/}=@F[4..7]; @a{qw/A C G T/}=@F[13..16]; $T= delete $a{$F[2]}; @l=sort {$a{$b} <=> $a{$a}} keys %a; $r= sprintf "%0.4f",$F[17]/$F[19];if($F[19]>=$Tdep && $r >= $Rate){print join "\t", @F[0],$F[1]-1,$F[1],"1;$F[2]/$F[21];$F[10]/$F[8];$F[19]/$F[17];$r;$F[0];@{[$F[1]-1]};$F[1]"}' -- -Tdep=30 -Rate=0.3 $1.bam.sorted.bam.pileup.AlleleCnt.var > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed

## make input
perl -F'\t' -anle'@l=split ";",$F[3]; print join "\t",@F[0..2],$l[1] ' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input
perl -F'\t' -anle'@l=split /\|/, ${[split ";",$F[3]]}[1]; ($ref,$l[0])=@{[split /\//,$l[0]]}; %h=();for (@l){ tr/acgtn,/ACGTN./; $h{$_}++ } @keys = keys %h; print join "\t", @F[0..2],"$ref/$keys[0]" if @keys == 1  ' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input

## get cds,intron,up,down,sp
GetVarAnnotation.pl --in-file $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input > /dev/null
GetVarAnnotation.INDEL.pl --in-file $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input > /dev/null


## get make tmp
perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..14])' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.tmp
perl -F"\t" -anle'print join "\t",@F[0..2],(join ",",@F[3..15])' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.tmp

## get dbSNP
perl -F'\t' -anle'$id="$F[0]:$F[2]";@ARGV ? $h{$id}=$F[3] : print "$_\t$h{$id}"' /home/adminrig/Genome/SNP/snp131.single.bed $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.tmp > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS
perl -F'\t' -anle'$id="$F[0]:$F[2]"; if(@ARGV){push @{$h{$id}}, $F[3] if $F[3] !~ /single/} else { @list=split ",", $F[3]; @l=split /\|/,$list[12]; $list[0]=~/\.[\+-]\d+(\w+)/;$ref=$1;$found="";$line=$_; if(/insertion/){ $F[2]++;$id2="$F[0]:$F[2]"; for $i( @{$h{$id}}, @{$h{$id2}} ){ next if /LARGE/; ($rs,$geno,$type)=split ",", $i; map { $found=$i if $ref eq $_ } split /\//,$geno; } print "$line\t$found"}elsif(/deletion/){$id="$F[0]:$l[2]"; $id2="$F[0]:$l[1]"; for $i( @{$h{$id}}, @{$h{$id2}} ){ next if /LARGE/; ($rs,$geno,$type)=split ",", $i; map { $found=$i if $ref eq $_ } split /\//,$geno; } print "$line\t$found" } } ' ~/Genome/SNP/snp131.bed $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.tmp > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS

perl -F'\t' -anle'@F[15..18]=@F[16..18,15];print join "\t",@F' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.tmp
mv -f $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.tmp $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS


## tr "," "\t"
perl -i.bak -ple's/,/\t/g' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS
perl -i.bak -ple's/,/\t/g' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS


## get read count ref/var
perl -F"\t" -anle'$id=join "-",@F[0..2]; if(@ARGV){@l=split ";",$F[3];$h{$id}=join "\t",@l[2..4]} else{ $F[19]=$h{$id};print join "\t",@F }' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt
perl -F"\t" -anle'$id=join "-",@F[0..2]; if(@ARGV){@l=split ";",$F[3];$h{$id}=join "\t",@l[2..4]} else{ $F[19]=$h{$id};print join "\t",@F }' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt



## divide to on and off target
## single
perl -F'\t' -anle'print join "\t", @F[0..2],(join ";",@F[3..$#F])' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp
intersectBed -a $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp -b $TILE -u | sed 's/;/\t/g' > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget
intersectBed -a $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp -b $TILE -v | sed 's/;/\t/g' > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget
## INDEL
perl -F'\t' -anle'print join "\t", @F[0..2],(join ";",@F[3..$#F])' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt  >  $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp
intersectBed -a $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp -b $TILE -u | sed 's/;/\t/g' > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget
intersectBed -a $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp -b $TILE -v | sed 's/;/\t/g' > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget
## Rearrange
perl -F'\t' -anle'@F[15..18]=@F[16..18,15];($t,$s,$e)=split /\|/,$F[18]; @F[1,2]=($s-1,$e) if $t eq "deletion";print join "\t",@F' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.tmp
mv -f $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.tmp $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget

perl -F'\t' -anle'@F[15..18]=@F[16..18,15];($t,$s,$e)=split /\|/,$F[18]; @F[1,2]=($s-1,$e) if $t eq "deletion";print join "\t",@F' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.tmp
mv -f $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.tmp $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget


## get Var dist matrix
## single
perl -F'\t' -MMin -asne'$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget
perl -F'\t' -MMin -asne'$type= $F[15]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget
## INDEL
perl -F'\t' -MMin -asne'$type= $F[16]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget
perl -F'\t' -MMin -asne'$type= $F[16]=~/\d+/ ?"dbSNP":"novel";  $F[6]=~s/ \d+$//; if($F[6]=~/CDS/){ $F[6] = $F[11] eq $F[12]?"CDS Syn":"CDS Nonsyn"} $h{"$F[0]:$F[2]"}{"$type-$F[6]"}++ }{ mmfss("$out.Var.count",%h)' -- -out=$1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget

## get Var Stat
perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.Var.count.txt > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.Var.count.summary
perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.Var.count.txt > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.Var.count.summary

perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.Var.count.txt > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OnTarget.Var.count.summary
perl -F'\t' -MMin -anle'@col=split "\t" if $.==1; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}++ } @idx }{ h1c(%h)' $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.Var.count.txt > $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.OffTarget.Var.count.summary

## rm tmp file
rm -rf $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.tmp $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.bak $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp
rm -rf $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.tmp $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.bak $1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input.out.RS.DepthCnt.tmp


