#!/bin/sh

source ~/.bash_function


TMP=tmp.dir

if [ -f "$1" ];then

	if [ ! -d $TMP ];then
		mkdir tmp.dir
	fi

	#for i in `cat ~/Genome/GPS.lib/chromosome.whole`;do echo -e "qsub -N $i ~/src/short_read_assembly/bin/sub.mpileup $i $1\nsleep 10";done > mpileup.chr.batch.sh
	#sh mpileup.chr.batch.sh

	#perl -le'while($l=`qstat -u adminrig`){ $l=~/chr/ ? sleep 10 : print localtime()." " & exit}'

	cd tmp.dir
	cut -f1,3 ~/Genome/GPS.lib/RS.region > ~/Genome/GPS.lib/RS.region.mpileup
	for i in `ls chr? chr??`; do echo "[`date`] $i"; bcftools view -cg -l ~/Genome/GPS.lib/RS.region.mpileup $i > $i.vcf;done

	ls *.vcf | xargs -i bgzip {}
	vcf-concat *.vcf.gz > WholeGenome.vcf


	# vcf-concat s_1.bam.sorted.bam.bcf.var.raw.vcf.vcftools.recode.vcf WholeGenome.vcf | vcf.ref-fix.sh  > Disease.Final.vcf
	cat WholeGenome.vcf | vcf.ref-fix.sh  > Disease.Final.vcf

	# vcf.ref-fix.sh Disease.Final.vcf | vcf2GTsDPsGQs.sh > Disease.Final.vcf.detail
	# vcf.ref-fix.sh Disease.Final.vcf | vcf-to-tab > Disease.Final.vcf.geno

	vcf2GTsDPsGQs.sh Disease.Final.vcf > Disease.Final.vcf.detail
	cat Disease.Final.vcf | vcf-to-tab > Disease.Final.vcf.geno
	
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
}{ map { print join "\t", $_, @{$line{$_}} } sort keys %line
' ~/Genome/GPS.lib/RS.region Disease.Final.vcf.geno Disease.Final.vcf.detail > Disease.Final.vcf.final
	
	GPS.backup.sh

else
	usage "bam.list"
fi





