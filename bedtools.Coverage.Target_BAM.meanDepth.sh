#!/bin/bash


. ~/.bash_function


#bedtools coverage -a BRCA.Amplicon.bed -b snuh0406_T.bam.AddRG.bam -mean  > out

bedtools=/home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools

if [ -f "$1" ] & [ -f "$2" ];then


	#TARGET_BED=$1
	#BAM=$2
	#/home/adminrig/workspace.min/Education/bedtools/bedtools2/bin/bedtools coverage -a $TARGET_BED -b $BAM -mean > $BAM.meanDP


	BED=$1
	BEDorBAM=$2
	DIR=$(dirname $BEDorBAM)

	#bedtools genomecov -ibam xxx.bam -g xxx.genome > Coverage
	#$bedtools -ibam xxx.bam -g xxx.genome > Coverage  

	$bedtools coverage -a $BED -b $BEDorBAM -hist > $BEDorBAM.Coverage
	$bedtools coverage -a $BED -b $BEDorBAM  > $BEDorBAM.Coverage.nohist
	$bedtools coverage -a $BED -b $BEDorBAM -mean > $BEDorBAM.Coverage.mean
	
	perl -nle'BEGIN{print join "\t", qw/file bases depth ontarget_rate/} if(/^all/){ @F=split "\t",$_; if($F[1]==0){$seqrate = 100-($F[4]*100)} $seq+=$F[1]*$F[2] } }{ print join "\t", $ARGV, $seq, $seq/$F[3], $seqrate' $BEDorBAM.Coverage >  $BEDorBAM.Coverage.depth
			 
	perl -F"\t" -anle'BEGIN{print join "\t", qw/all depth bases total_bp cover_rate total_cover_rate/;} next if !/^all/; if($F[1]==0){$Cov=sprintf "%.2f", (1-$F[4])*100; print join "\t", $_, "100.00"}elsif($F[1]<=1000){ print join "\t", $_, $Cov;$Cov=sprintf "%.2f", ($Cov-$F[4]*100); } ' $BEDorBAM.Coverage > $BEDorBAM.Coverage.DepthCov

	paste $BEDorBAM.Coverage.{nohist,mean} | cut -f1-3,6-9,15 | sed '1 i\chr\tstart\tend\treadcount\tcover_bp\ttarget_bp\tcoverage\tmean_dp' > $BEDorBAM.Coverage.DepthSummaryByIntervals

	#bedtools coverage [OPTIONS] -a <bed/gff/vcf> -b <bed/gff/vcf> -hist > Coverage
	#bedtools coverage [OPTIONS] -a xxx.bed -b $BED -mean > Coverage.mean

	mkdir $DIR/DepthCov && mv $BEDorBAM.Cov* bam2bed* $DIR/DepthCov

else	

	usage "TargetBed BEDorBAM"
fi

