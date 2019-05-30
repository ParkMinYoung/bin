
## ARGS 1 : ID
 ID=KP_005
# ID=$1

gunzip TSVC_variants.vcf.gz


## convert VCF : number chromosome, sample id
perl -i.bak -sple's/chr//; s/ion-sample/$id/ if /^#CHR/' -- -id=$ID TSVC_variants.vcf

## symbolic link
ln -s /home/adminrig/workspace.min/GSK.20121113/GSK.BAM/INTERVAL.VCF/Call/000001.1.intervals.snp.raw.vcf.CombineVariants.vcf
ln -s /home/adminrig/workspace.min/GSK.20121113/GSK.BAM/INTERVAL.VCF/Call/000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.idx

## extract ID from vcf
GenomeAnalysisTK.SelectVariantsFromSample 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf $ID 



INTERSECT=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.NumChr.bed


Folder=VCF.compare
mkdir $Folder

Hiseq=$(readlink -f 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.$ID.vcf)
IonProton=$(readlink -f TSVC_variants.vcf)

cd $Folder
ln -s $Hiseq Hiseq.vcf
ln -s $IonProton IonProton.vcf

## PASS or not or intersect
## DP : 1, 5, 10, 15, 20, 25, 30, 40, 50, 100, 200
## GQ : 50, 60, 70, 80, 90, 99

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

find simulation -type f | grep indv$ | sort | xargs grep ^KP  | \
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
                done

        done

done



find simulation.1 -type f | grep indv$ | sort | xargs grep ^KP  | \
perl -F'\t' -anle'
print join "\t", qw/DP HGQ IGQ Type N_CMP N_MIS P_MIS/ if $.==1;

/DP(\d+)-HGQ(\d+)-IGQ(\d+).(Intersect.)?diff/;
$type= $4 ? "intersect" : "all";
print join "\t", $1,$2,$3,$type,@F[1..$#F]' > DP.HGQ.IGQ.simulation.Discordant


ExtractDpGq.sh Hiseq.vcf
ExtractDpGq.sh IonProton.vcf

R CMD BATCH ~/src/short_read_assembly/bin/R/HiseqIonProton.compare.R


