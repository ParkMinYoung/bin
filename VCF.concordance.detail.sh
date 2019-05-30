#!/bin/sh

. ~/.bash_function
. ~/.GATKrc

if [ $# -eq 4 ];then

# 1st ID
# 2nd ID
# 1st VCF
# 2nd VCF

ID="$1--$2"
TOP_DIR="VCF.Detail.Concordance"
DIR="$TOP_DIR/$ID"
SIM="$TOP_DIR/$ID/simulation"
SIM1="$TOP_DIR/$ID/simulation.1"
mkdir -p $SIM $SIM1

ABS_VCF1=$(readlink -f $3)
ABS_VCF2=$(readlink -f $4)

VCF1=$1.vcf
VCF2=$2.vcf

cd $DIR
cp $ABS_VCF1 $VCF1
cp $ABS_VCF2 $VCF2

## convert VCF : number chromosome, sample id
perl -i.bak -sple's/chr//; s/FORMAT\t.+/FORMAT\t$id/ if /^#CHR/' -- -id=$ID $VCF1 
perl -i.bak -sple's/chr//; s/FORMAT\t.+/FORMAT\t$id/ if /^#CHR/' -- -id=$ID $VCF2 


INTERSECT=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.NumChr.bed.100.bed

## PASS or not or intersect
## DP : 1, 5, 10, 15, 20, 25, 30, 40, 50, 100, 200
## GQ : 50, 60, 70, 80, 90, 99
#vcftools.concordance.subtype.summary.sh Hiseq.vcf IonProton.vcf
vcftools.concordance.subtype.summary.sh $VCF1 $VCF2

vcftools --vcf $VCF1 --diff $VCF2 --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-filtered-all --out PASS
vcftools --vcf $VCF1 --diff $VCF2 --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --out ALL

cd $DIR
ln -s $VCF1 Hiseq.vcf
ln -s $VCF2 IonProton.vcf

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

DP.HGQ.IGQ.simulation.Discordant.sh > DP.HGQ.IGQ.simulation.Discordant.2
(head -1 DP.HGQ.IGQ.simulation.Discordant.2; grep SNV  DP.HGQ.IGQ.simulation.Discordant.2) > DP.HGQ.IGQ.simulation.Discordant.2.SNV


ExtractDpGq.sh Hiseq.vcf
ExtractDpGq.sh IonProton.vcf

R CMD BATCH ~/src/short_read_assembly/bin/R/HiseqIonProton.compare.R


else
	usage "A_ID B_ID A.vcf B.vcf"
fi

