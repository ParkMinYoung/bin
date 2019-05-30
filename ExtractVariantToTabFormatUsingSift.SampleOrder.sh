#!/bin/bash

. ~/.bash_function

if [ $# -ge 3 ] ;then

snpsift='java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar'

cat $1 | $snpsift filter "(isHet(GEN[$3])) | (isHom( GEN[$3] ) & isVariant( GEN[$3] )) " |  /home/adminrig/src/SNPEFF/snpEff_4_3/scripts/vcfEffOnePerLine.pl |  $snpsift extractFields  -s "," -e "." - CHROM POS ID REF ALT GEN[$3].GT GEN[$3].DP GEN[$3].AD ANN[*].EFFECT ANN[*].IMPACT ANN[*].GENE ANN[*].GENEID ANN[*].FEATURE ANN[*].FEATUREID ANN[*].BIOTYPE ANN[*].RANK ANN[*].HGVS_C ANN[*].HGVS_P ANN[*].CDNA_POS ANN[*].CDNA_LEN ANN[*].CDS_POS ANN[*].CDS_LEN ANN[*].AA_POS ANN[*].AA_LEN ANN[*].DISTANCE > $2.tab

AddHeader.sh $2.tab  $2.tab.header $( head -1 $2.tab | tr "\t" "\n" | perl -nle's/^(#|(GEN.+|ANN.+)\.)//;print')

if [ -f "$4" ];then

   extract.h.sh $4 1 $2.tab.header 11 > $2.tab.header.GeneList 

fi



else
	echo "ID number is 0-based index"	
	usage "VCF ID ID_number [GeneList]"

fi


#cat 491.HC.genotypeGVCF.analysisready.pass.snpeff.vcf | snpsift filter "( EFF[*].GENE = 'HDAC9' )" > HDAC9.vcf



# excute time : 2017-12-08 16:36:00 : grep list
#vcf.sample.sh 491.HC.genotypeGVCF.analysisready.pass.snpeff.vcf | grep JP > JPX


# excute time : 2017-12-08 16:51:20 : extract sample var
#for i in `cat JPX`; do echo $i ; ./extract.variant.sh HDAC9.vcf $i ; done &



#for i in *.tab; do AddHeader.sh $i  $i.header $(ls *.tab | head -1| xargs head -1 | tr "\t" "\n" | perl -nle's/^(#|(GEN.+|ANN.+)\.)//;print') ; done 
# excute time : 2017-12-08 17:04:07 : make file
#AddRow.w.sh HDAC9.all '(.+).tab' ID *.tab.header  | grep Add | sh 


