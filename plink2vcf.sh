#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

## extrac SNPolisher Passed maker without AFFX marker

LIB_CSV=/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab
LIB_CSV=$1

PlinkAlleleUpdate4VCFfrom.sh $LIB_CSV
# $LIB_CSV.allele
# $LIB_CSV.Affy2RefAllele


## create VCF Formed allele plink
INPUT=AxiomGT1.calls.txt.extract.plink_fwd.gender
OUTPUT=$INPUT.VCFform
plink --bfile $INPUT --update-alleles $LIB_CSV.allele --make-bed --out $OUTPUT --noweb


## create VCF update pos for deletion 20151110 bug fix
cut -f1,9 $LIB_CSV.allele  | sed -n '2,$'p > $LIB_CSV.allele.map
plink --bfile $OUTPUT --update-map $LIB_CSV.allele.map --make-bed --out $OUTPUT.PosUpdated --noweb


## create fixed ref allele plink
INPUT=$OUTPUT.PosUpdated
OUTPUT=$INPUT.fixedRef
plink --bfile $INPUT --reference-allele $LIB_CSV.Affy2RefAllele --make-bed --out $OUTPUT --noweb

## extrac SNPolisher Passed Maker
#plink --bfile $OUTPUT --extract SNPolisherPassSNV --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass --noweb

## extract rs_id or affy_id
perl -F'\t' -anle'
if(/^AX/){
    $affy2rs{$F[0]} = $F[2] eq "---" ? $F[0] : $F[2];
    $h{$F[2]}++;

}

}{

map { $rs=$affy2rs{$_}; $h{$rs} == 1 ? print join "\t", $_, $affy2rs{$_} : print join "\t", $_, $_} sort keys %h
' $LIB_CSV > updateID

## convert affy_id to rs_id
#plink --bfile AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass --update-map updateID --update-name --make-bed --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele --noweb


## making real id
#perl -F'\s+' -i.bak -aple'$F[0]=~/_\w{2,3}_(.+?)(_2|_3)?(.CEL)?/;@F[0,1]=($1,$1); $_= join " ", @F'  AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele.fam
perl -F'\s+' -i.bak -aple'$F[0]=~s/_\d+//;@F[0,1]=@F[0,0]; $_= join " ", @F;' AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele.fam

#/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele --a2-allele $LIB_CSV.Affy2RefAllele --recode vcf-iid --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele --real-ref-alleles
/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $OUTPUT --a2-allele $LIB_CSV.Affy2RefAllele --recode vcf-iid --out AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele --real-ref-alleles

mkdir submit

cat AxiomGT1.calls.txt.extract.plink_fwd.gender.SNPolisherPass.updateAllele.vcf | gzip -c > submit/SNUHDMEX.vcf.gz
zip submit/Plink.Affy.zip $OUTPUT.{bim,fam,bed,log}

#\cp -f /home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_SNUHDMEX.na34.annot.csv.zip submit/* ~/workspace.min/211.174.205.50/SNUHMDMEX.Final

else
	usage "/home/adminrig/workspace.min/AFFX/untested_library_files/Axiom_KORV1_0.na34.annot.csv.tab"
fi

