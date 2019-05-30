
#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

vcftools --vcf $1 --keep JPTandCHB.ind  --maf 0.05  --plink --out $1.SNV.plink # ok
plink --file $1.SNV.plink --r2 --ld-window 999999 --show-tags all --tag-r2 0.8 --tag-kb 1000 --out $1.SNV.plink.tag --noweb 
GetUniqTags.sh $1.SNV.plink.tag.tags.list

else

	usage "XXX.vcf"
fi


