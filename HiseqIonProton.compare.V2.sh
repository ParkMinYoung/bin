#!/bin/sh

. ~/.bash_function
. ~/.GATKrc

if [ $# -eq 3 ];then

## ARGS 1 : ID
#!# ID=KP_005
# ID=$1
ID=$1

DIR=$(dirname $2)
IN_GZ_VCF=$(basename $2)
cd $DIR

#gunzip TSVC_variants.vcf.gz
gunzip $IN_GZ_VCF
IN_VCF=${IN_GZ_VCF/%.gz/}



## convert VCF : number chromosome, sample id
#perl -i.bak -sple's/chr//; s/ion-sample/$id/ if /^#CHR/' -- -id=$ID TSVC_variants.vcf
perl -i.bak -sple's/chr//; s/ion-sample/$id/ if /^#CHR/' -- -id=$ID $IN_VCF

## symbolic link
H_VCF=$3
H_IDX=$H_VCF.idx

ln -s $H_VCF
ln -s $H_IDX 

## extract ID from vcf
SYM_H_VCF=$(basename $H_VCF)
GenomeAnalysisTK.SelectVariantsFromSample $SYM_H_VCF $ID 


INTERSECT=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.NumChr.bed.100.bed


Folder=VCF.compare
mkdir $Folder

Hiseq=$(readlink -f $SYM_H_VCF.$ID.vcf)
IonProton=$(readlink -f $IN_VCF)

cd $Folder
ln -s $Hiseq Hiseq.vcf
ln -s $IonProton IonProton.vcf

## PASS or not or intersect
## DP : 1, 5, 10, 15, 20, 25, 30, 40, 50, 100, 200
## GQ : 50, 60, 70, 80, 90, 99
vcftools.concordance.subtype.summary.sh Hiseq.vcf IonProton.vcf

vcftools --vcf Hiseq.vcf --diff IonProton.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --out PASS
vcftools --vcf Hiseq.vcf --diff IonProton.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out ALL

mkdir simulation
for i in 1 5 10 15 20 25 30 40 50 100 200; 
	do
	for j in 1 10 20 30 40 50 60 70 80 90 99
		do 
		echo "`date` Start DP $i GQ $j"
		cat Hiseq.vcf | java -jar ~/src/SNPEFF/snpEff_3_0/SnpSift.jar filter "( GEN[*].DP >= $i ) & ( GEN[*].GQ >= $j )" > simulation/Hiseq.vcf.DP$i.GQ$j.vcf
		cat IonProton.vcf | java -jar ~/src/SNPEFF/snpEff_3_0/SnpSift.jar filter "( GEN[*].DP >= $i ) & ( GEN[*].GQ >= $j )" > simulation/IonProton.vcf.DP$i.GQ$j.vcf
		vcftools --vcf simulation/Hiseq.vcf.DP$i.GQ$j.vcf --diff simulation/IonProton.vcf.DP$i.GQ$j.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --minDP $i --minGQ $j  --maxDP 10000 --out simulation/DP$i-GQ$j >& /dev/null 
		vcftools --vcf simulation/Hiseq.vcf.DP$i.GQ$j.vcf --diff simulation/IonProton.vcf.DP$i.GQ$j.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --minDP $i --minGQ $j  --maxDP 10000 --out simulation/DP$i-GQ$j.Intersect --bed $INTERSECT >& /dev/null 

	done

done

##############################################################################
##############################################################################

find simulation -type f | grep indv$ | sort | xargs grep ^$ID  | \
perl -F'\t' -anle'
print join "\t", qw/DP GQ Type N_CMP N_MIS P_MIS/ if $.==1;

/DP(\d+)-GQ(\d+).(Intersect.)?diff/;
$type= $3 ? "intersect" : "all";
print join "\t", $1,$2,$type,@F[1..$#F]' > DP.GQ.simulation.Discordant




##############################################################################
##############################################################################


mkdir simulation.1

for i in 10 15 20;
        do
        for j in 1 10 20 30 40 50 60 70 80 90 99
                do

                cat Hiseq.vcf | java -jar ~/src/SNPEFF/snpEff_3_0/SnpSift.jar filter "( GEN[*].DP >= $i ) & ( GEN[*].GQ >= $j )" > simulation.1/Hiseq.vcf.DP$i.GQ$j.vcf

                for k in 1 10 20 30 40 50 60 70 80 90 99
                        do
                        echo "`date` Start DP $i HGQ $j IGQ $k"

                        cat IonProton.vcf | java -jar ~/src/SNPEFF/snpEff_3_0/SnpSift.jar filter "( GEN[*].DP >= $i ) & ( GEN[*].GQ >= $k )" > simulation.1/IonProton.vcf.DP$i.GQ$k.vcf

                        vcftools --vcf simulation.1/Hiseq.vcf.DP$i.GQ$j.vcf --diff simulation.1/IonProton.vcf.DP$i.GQ$k.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --minDP $i --maxDP 10000 --out simulation.1/DP$i-HGQ$j-IGQ$k >& /dev/null
                        vcftools --vcf simulation.1/Hiseq.vcf.DP$i.GQ$j.vcf --diff simulation.1/IonProton.vcf.DP$i.GQ$k.vcf --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --minDP $i --maxDP 10000 --out simulation.1/DP$i-HGQ$j-IGQ$k.Intersect --bed $INTERSECT >& /dev/null
						vcftools.concordance.subtype.summary.sh simulation.1/Hiseq.vcf.DP$i.GQ$j.vcf simulation.1/IonProton.vcf.DP$i.GQ$k.vcf 
                done

        done

done


find simulation.1 -type f | grep indv$ | sort | xargs grep ^$ID  | \
perl -F'\t' -anle'
print join "\t", qw/DP HGQ IGQ Type N_CMP N_MIS P_MIS/ if $.==1;

/DP(\d+)-HGQ(\d+)-IGQ(\d+).(Intersect.)?diff/;
$type= $4 ? "intersect" : "all";
print join "\t", $1,$2,$3,$type,@F[1..$#F]' > DP.HGQ.IGQ.simulation.Discordant


ExtractDpGq.sh Hiseq.vcf
ExtractDpGq.sh IonProton.vcf

R CMD BATCH ~/src/short_read_assembly/bin/R/HiseqIonProton.compare.R


else
	usage "SampleID Proton_GZip_VCF Hiseq_VCF"
fi

