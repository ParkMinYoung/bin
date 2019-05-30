#!/bin/bash

. ~/.bash_function

SNPEFF_DIR=/home/adminrig/src/SNPEFF/snpEff_4_3Q/

snpeff="java -Xmx32g -jar $SNPEFF_DIR/snpEff.jar"
snpsift="java -Xmx32g -jar $SNPEFF_DIR/SnpSift.jar"
#snpsift="java -Xmx512g -jar /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar"

if [ -f "$1" ]; then


# excute time : 2018-03-23 13:35:54 : step 1 : make tab file, chr, start, end, ref, alt, axid, loctype
perl -F'\t' -anle'if($.>1){ print join "\t", @F[4..6,13,14,0,3] }' $1 > step1 


# excute time : 2018-03-23 13:49:38 : step 2 : make indel bed file
perl -F"\t" -anle'$geno=$F[3].$F[4];  if($geno =~/-/){ print join "\t", $F[0], $F[1]-2, $F[1]-1, (join ";", @F[0..4]) }' step1 > step2 


# excute time : 2018-03-23 13:52:59 : step 3 : get previous base 
bedtools getfasta -fi /home/adminrig/src/GATK.2.0/resource.bundle/2.8/b37/human_g1k_v37.fasta -bed step2 -name -tab -fo step3 


# excute time : 2018-03-23 14:32:17 : step 4 : tab 2 vcf indel format
VCF_indel_format.sh > step4


# excute time : 2018-03-23 15:03:08 : step 5 : make tab
awk '{print $1"\t"$2"\t"$6"\t"$4"\t"$5}' step4 | perl -F'\t' -anle'$F[0]="M" if $F[0] eq "MT"; if(/\//){ @F[3,4] = split "\/", $F[4];} print join "\t", @F ' > step5 


# excute time : 2018-03-23 15:03:35 : step 6 : make vcf
$src/Tab2VCF.sh step5 


# 20180529 modification

I=$1
input=${I%.csv.tab}.vcf
ln -s step5.vcf $input


## snpeff annotation
sed 's/^M/MT/' $input | $snpeff -i vcf -o vcf -config $SNPEFF_DIR/snpEff.config GRCh37.75 - 1> $input.snpeff.vcf 2> $input.snpeff.vcf.log

## make tab limited files
snpeff_extract_MPL.sh $input.snpeff.vcf



else
	usage "Axiom_SMOKESC1.na34.annot.csv.tab"
fi



# excute time : 2018-03-23 15:43:16 : annot
# sed 's/^M/MT/' step5.vcf | java -Xmx16G -jar /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar eff GRCh37.75 - > annot.vcf
# sed 's/^M/MT/' step5.vcf | java -Xmx16G -jar /home/adminrig/src/SNPEFF/snpEff_4_2/snpEff.jar ann GRCh37.75 - > annot.vcf 


# excute time : 2018-03-26 09:22:39 : symbolic
# snpsift='java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_1/SnpSift.jar'


# excute time : 2018-03-26 09:41:04 : download
# refFlat.down.sh 


# excute time : 2018-03-26 09:42:32 : make bed file from refFlat.txt
#$src/GetGeneBedFromUCSCrefFlat.sh  refFlat.txt 


# excute time : 2018-03-26 09:43:40 : link
#ln -s /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_smokesc1/Axiom_SMOKESC1.na34.annot.csv.tab.bed ./


# excute time : 2018-03-26 09:44:33 : count in gene region
# bedtools intersect -a refFlat.Gene.bed -b Axiom_SMOKESC1.na34.annot.csv.tab.bed -c > refFlat.Gene.bed.count


# excute time : 2018-03-26 10:12:13 : 
# $snpsift extractFields annot.vcf  -s "," -e "." CHROM POS ID REF ALT  "ANN[*].GENE" "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" > annot.vcf.data 


#$snpsift extractFields $input.snpeff.vcf  -s "," -e "." CHROM POS ID REF ALT  "ANN[*].GENE" "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" > $input.snpeff.vcf.data
#snpeff_reheader.sh $input.snpeff.vcf.data
#\mv -f $input.snpeff.vcf.data.header $input.snpeff.vcf.data
