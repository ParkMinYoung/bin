. ~/.GATKrc


MPILEUP=Multi.mpileup
samtools mpileup -f $REF_Short -d 10000 -l /home/adminrig/Genome/Fludigm.EGFR/EGFR.bed.NumChr  `ls *bam | sort` > $MPILEUP 2> $MPILEUP.log

#for i in {3,4,5,6,7,8,9,10}
for i in 3

	do 

#samtools mpileup -f $REF_Short `ls *bam | sort` | java -jar $VARSCAN mpileup2snp --min-avg-qual 25 --min-coverage 50 --min-reads2 $i --min-freq-for-hom 0.85 --strand-filter 1 --variants  > Het.$i.txt
#samtools mpileup -f $REF_Short `ls *bam | sort` | java -jar $VARSCAN mpileup2snp --min-avg-qual 25 --min-coverage 50 --min-reads2 $i --min-freq-for-hom 0.85 --strand-filter 1 --variants  --output-vcf 1 > Het.$i.vcf
java -jar $VARSCAN mpileup2snp $MPILEUP --min-avg-qual 25 --min-coverage 10 --min-var-freq 0.15 --min-reads2 $i --min-freq-for-hom 0.85 --strand-filter 1 --variants  > Het.$i.txt 2>  Het.$i.txt.log
java -jar $VARSCAN mpileup2snp $MPILEUP --min-avg-qual 25 --min-coverage 10 --min-var-freq 0.15 --min-reads2 $i --min-freq-for-hom 0.85 --strand-filter 1 --variants  --output-vcf 1 > Het.$i.vcf 2> Het.$i.vcf.log

done
