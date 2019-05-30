
#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

dbNSFP=/export/home/adminrig/workspace.min/KOREAN_CHIP/v2/dbNSFP2.4.txt.gz

vcf2GT.sh $1 > $1.GT.txt
sortBed -i $1 > $1.sort.vcf
#ln -s $(readlink -f $1) $1.sort.vcf

## dbSNP Annotation
java -Xmx16g -jar /home/adminrig/src/SNPEFF/snpEff_3_6/SnpSift.jar annotate /home/adminrig/src/GATK.2.0/resource.bundle/2.8/b37/dbsnp_138.b37.vcf $1.sort.vcf > $1.sort.annotated.vcf 2> $1.sort.annotated.vcf.err
#DBSNPVCF=/home/adminrig/src/GATK.2.0/resource.bundle/2.8/b37/dbsnp_138.b37.vcf
#v20131023
# /home/adminrig/src/GATK.2.0/resource.bundle/2.8/hg19/dbsnp_138.hg19.vcf

## SNPEFF
#java -Xmx16g -jar /home/adminrig/src/SNPEFF/snpEff_3_6/snpEff.jar eff GRCh37.75 -c /home/adminrig/src/SNPEFF/snpEff_3_6/snpEff.config -noStats -t 10 -hgvs -i vcf -o vcf $1.sort.annotated.vcf  > $1.sort.annotated.snpeff.vcf 2> $1.sort.annotated.snpeff.vcf.err
java -Xmx16g -jar /home/adminrig/src/SNPEFF/snpEff_3_6/snpEff.jar eff GRCh37.75 -c /home/adminrig/src/SNPEFF/snpEff_3_6/snpEff.config $1.sort.annotated.vcf > $1.sort.annotated.snpeff.vcf 2> $1.sort.annotated.snpeff.vcf.err

## dbNSFP Annotation
java  -Xmx16g -jar /home/adminrig/src/SNPEFF/snpEff_3_6/SnpSift.jar dbnsfp -v $dbNSFP $1.sort.annotated.snpeff.vcf > $1.sort.annotated.snpeff.dbNSFP2.vcf 2> $1.sort.annotated.snpeff.dbNSFP2.vcf.err

SNPEFF.1.sh $1.sort.annotated.snpeff.dbNSFP2.vcf
SNPEFF.2.sh $1.sort.annotated.snpeff.dbNSFP2.vcf.out 

join.sh $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt \
		$1.GT.txt \
        "1,2,4,5" \
        "1,2,4,5" \
        "6,7,8,9,10,11,12,13,14,15,16,17" \
         > $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT


VCF2SNPEff.Report2Count.sh $1.gz.AleleCountPerStrand $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT >  $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT.Count


SNPEFF.3.sh  $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT.Count > $1.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT.Count.PerVariant

else
        usage "XXX.vcf"
fi
