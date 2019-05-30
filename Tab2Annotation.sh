Tab2VCFformatStart2End.sh $1
PWD=$PWD
ssh -q -x 211.174.205.93 "cd $PWD && batch.SGE.93.sh VCF2SNPEff3_6.sh $1.Start2End.tab.vcf | sh"

VCF2ANNOVAR.sh $1.Start2End.tab.vcf

