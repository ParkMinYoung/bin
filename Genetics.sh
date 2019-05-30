#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then

		# needed bamfile list
		BAM=$1
		bam2bcf.sh `cat $BAM` >& bam2bcf.sh.`date +%Y%m%d`.log 

		OUT=$(head -1 $BAM)
		OUTVCF=$OUT.bcf.var.raw.vcf
		RefidVcf=$OUTVCF.vcftools

		zcat $OUTVCF.gz | sed /ID=INDEL/d > $OUTVCF


		##### Get interval variation #####
		# Parameters as interpreted:
		vcftools --out $RefidVcf --recode --vcf $OUTVCF --bed /home/adminrig/Genome/GPS.lib/Disease.merge.bed



		# ref region variation 
		GeneticRS=$2

		# cut -f1,3 ~/Genome/GPS.lib/RS.region.genectic > ~/Genome/GPS.lib/RS.region.genectic.mpileup
		cut -f1,3 $GeneticRS > $GeneticRS.mpileup

		cd tmp.dir
		# for i in `ls chr? chr??`; do echo "[`date`] $i"; bcftools view -cg -l ~/Genome/GPS.lib/RS.region.genectic.mpileup $i > $i.vcf;done
		for i in `ls chr? chr??`; do echo "[`date`] $i"; bcftools view -cg -l $GeneticRS.mpileup $i > $i.vcf;done
		ls *.vcf | xargs -i bgzip {}
		vcf-concat *.vcf.gz > WholeGenome.vcf

		# vcf-concat ../s_3/s_3.bam.sorted.bam.bcf.var.raw.vcf.vcftools.recode.vcf WholeGenome.vcf | vcf.ref-fix.sh  > Disease.Final.vcf
		vcf-concat $RefidVcf.recode.vcf WholeGenome.vcf | vcf.ref-fix.sh  > Disease.Final.vcf

		vcf.ref-fix.sh Disease.Final.vcf | vcf2GTsDPsGQs.sh > Disease.Final.vcf.detail
		vcf.ref-fix.sh Disease.Final.vcf | vcf-to-tab > Disease.Final.vcf.geno


		perl -F'\t' -MMin -anle'$key="$F[0]\t$F[1]";
		if(@ARGV==2){ $line{"$F[0]\t$F[2]"}[0]=$F[3]}
		elsif(@ARGV==1){
				$c=@sam=@F[3..$#F];
				$col=3+$c-1;
				@{$line{$key}}[3..$col]= @sam
		}else{
				$d=@sam=@F[4..$#F];
				$dol=$col+1+$d;
				@{$line{$key}}[1,2,$col+1..$dol]= @F[2..$#F]
		}
		}{ map { print join "\t", $_, @{$line{$_}} } sort keys %line' $GeneticRS Disease.Final.vcf.geno Disease.Final.vcf.detail > Disease.Final.vcf.final


		vcf2Annotation.pair.sh Disease.Final.vcf


		perl -F'\t' -MMin -anle'if(@ARGV){ @{$h{"$F[0]\t$F[1]"}}=@F }
		else{$k="$F[0]\t$F[2]"; $n=@{$h{$k}}+18; @F[18..$n]=@{$h{$k}}; print join "\t", @F
		}' Disease.Final.vcf.final Disease.Final.vcf.RS > Disease.summary
		
		GPS.backup.sh

else
	usage "bam.list ~/Genome/GPS.lib/RS.region.genectic"
fi


##### Get interval variation #####
# Parameters as interpreted:
#	--out s_3.bam.sorted.bam.bcf.var.raw.vcf.vcftools
#	--recode
#	--vcf s_3.bam.sorted.bam.bcf.var.raw.vcf
#	--bed /home/adminrig/Genome/GPS.lib/Disease.merge.bed

