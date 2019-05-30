. ~/.GATKrc


MPILEUP=Multi.mpileup
samtools mpileup -f $UCSChg19 -d 1000 -l $SureSelectCHRBED  `ls *bam | sort` > $MPILEUP 2> $MPILEUP.log


#java -jar $VARSCAN mpileup2snp $MPILEUP --min-avg-qual 25 --min-coverage 10 --min-var-freq 0.15 --min-reads2 $i --min-freq-for-hom 0.85 --strand-filter 1 --variants  > Het.$i.txt 2>  Het.$i.txt.log
java -jar $VARSCAN mpileup2snp $MPILEUP --min-avg-qual 20 --min-coverage 8 --min-var-freq 0.15 --min-reads2 3 --min-freq-for-hom 0.85 --strand-filter 1 --variants  --output-vcf 1 > Varscan.Call.SNP.vcf 2> Varscan.Call.SNP.vcf.log

java -jar $VARSCAN pileup2indel $MPILEUP --min-avg-qual 20 --min-coverage 8 --min-var-freq 0.15 --min-reads2 3 --min-freq-for-hom 0.85 --strand-filter 1 --variants  --output-vcf 1 > Varscan.Call.INDEL.vcf 2> Varscan.Call.INDEL.vcf.log



