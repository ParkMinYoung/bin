#!/bin/sh

if [ -f "$1" ];then

RsFinder.sh $1
Tab2Annotation.sh $1.output.tab
echo "output is : $1.output.tab.Start2End.tab.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt"
vv $1.output.tab.Start2End.tab.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt

# $1.output.tab.Start2End.tab.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt

else
	usage "rslit"
fi

