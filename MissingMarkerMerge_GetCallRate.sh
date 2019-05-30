
MissMarkers=$1
findMarkers=$2
PLINK=$3
FAM=$PLINK.fam
EAS_num="EAS_"$4


#MissMarkers=EastAsian.frq.tab.1.SortGeno.missing
#findMarkers=EastAsian.frq.tab.1.SortGeno.found
#PLINK=MergePlink.info_scoreOver0.8.SortedGeno
#FAM=$PLINK.fam
#EAS_num="EAS_"5

# for MergePlink.info_scoreOver0.8
# make tped for missing marker
perl -F':' -asnle' next if /^SNP/; print join "\t", $F[0], $_, 0, @F[1],("0 0")x$num ' -- -num=96 $MissMarkers > $MissMarkers.tped
\cp -f $FAM $MissMarkers.tfam

## convert missing tped to binary : step 1
plink2 --tfile $MissMarkers --make-bed --out $MissMarkers --allow-no-sex --threads 10

## extract MAF 5% Markers from orginal bam : step 2
plink2 --bfile $PLINK --extract $findMarkers --make-bed --out $PLINK.$EAS_num --allow-no-sex --threads 10

## step 1 + 2 : step 3
plink2 --bfile $PLINK.$EAS_num --bmerge $MissMarkers.{bed,bim,fam} --make-bed --out $PLINK.$EAS_num.final --allow-no-sex --threads 10


plink2 --bfile $PLINK.$EAS_num.final --missing --out $PLINK.$EAS_num.final.CR --allow-no-sex --threads 10


