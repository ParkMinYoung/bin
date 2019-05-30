vcftools --vcf $1 --plink --out $1.plink
perl -i.bak -ple's/DNALink.PE.//g' $1.plink.ped 
plink --file $1.plink --make-bed --out $1.plink.binary --noweb


## allele updates 
## /home/adminrig/Genome/1000Genomes/20130502/SMC.YangJunMo.WES 
 ##perl -F'\t' -anle'next if /^#/; if($F[2] eq "."){$id="$F[0]:$F[1]"}else{$id=$F[2]} print join "\t", $id, @F[3,4]' $1 > ID2Geno
 ##perl -F'\t' -anle'print if "$F[4]$F[5]" =~/0/' $1.plink.binary.bim > AltMono
 ##join.h.sh AltMono ID2Geno 2 1 "2,3" | cut -f2,5-8 >  AltMono.join
 ##plink --bfile $1.plink --update-alleles AltMono.join --make-bed --out $1.plink.binary.fix --noweb 

