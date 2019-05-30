HUMANDB=/home/adminrig/src/ANNVAR/annovar/humandb


## create annovar input file 
convert2annovar.pl $1 -format vcf4 -includeinfo > $1.annovar 2> $1.annovar.log

## create dbsnp135 annotation file
annotate_variation.pl -filter -dbtype snp135 -buildver hg19 $1.annovar $HUMANDB 2> $1.annovar.dbSNP135.log

## create region annotation file
annotate_variation.pl -buildver hg19 -geneanno $1.annovar $HUMANDB 2> $1.annovar.gene.log


## simple annvar input file
convert2annovar.pl $1 -format vcf4 > $1.simple.annovar 2> $1.simple.annovar.log

## simple create region annotation file
annotate_variation.pl -buildver hg19 -geneanno $1.simple.annovar $HUMANDB 

## simple CDS SNP input file 
cut -f4- $1.simple.annovar.exonic_variant_function > $1.simple.annovar.exonic_variant_function.CodingSNP

annotate_variation.pl -buildver hg19 -filter -dbtype avsift $1.simple.annovar.exonic_variant_function.CodingSNP $HUMANDB 2> $1.simple.annovar.exonic_variant_function.CodingSNP.avsift.log
#annotate_variation.pl -buildver hg19 -filter -dbtype avsift 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.simple.annovar.exonic_variant_function.CodingSNP -sift_threshold 0 /home/adminrig/src/ANNVAR/annovar/humandb  2> 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.simple.annovar.exonic_variant_function.CodingSNP.avsift.log





## Get Header
grep ^# $1 > $1.header
#grep ^# 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf > 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header

## bug fix
perl -F'\t' -i.bak -aple'@F[5..$#F-1]=@F[6..$#F] if $F[6] =~ /chr/; $_= join "\t", @F' $1.annovar.hg19_snp135_filtered

perl -F'\t' -anle'
if($ARGV=~/header$/){
		print
}elsif($ARGV=~/snp135_dropped$/){
		$F[9]=$F[1];
		print join "\t", @F[7..$#F];
}elsif($ARGV=~/snp135_filtered$/){
		print join "\t", @F[5..$#F];
}' $1.header $1.annovar.hg19_snp135_dropped $1.annovar.hg19_snp135_filtered > $1.header.dbsnp135.vcf
# 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.annovar.hg19_snp135_dropped 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.annovar.hg19_snp135_filtered > 000001.1.intervals.snp.raw.vcf.CombineVariants.vcf.header.dbsnp135.vcf

GenomeAnalysisTK.EFFSNP.66 GRCh37.66 $1.header.dbsnp135.vcf
Eff.OutParsing.sh $1.header.dbsnp135.vcf.GRCh37.66.vcf

## create annovar input file 
AVIN=$1.header.dbsnp135.vcf.annovar

convert2annovar.pl $1.header.dbsnp135.vcf -format vcf4 -includeinfo > $AVIN 2> $AVIN.log

annotate_variation.pl -buildver hg19 -geneanno $AVIN $HUMANDB 2> $AVIN.gene.log

annotate_variation.pl -buildver hg19 -filter -dbtype avsift $AVIN $HUMANDB 2> $AVIN.avsift.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_gerp++ $AVIN $HUMANDB 2> $AVIN.ljb_gerp++.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_lrt $AVIN $HUMANDB 2> $AVIN.ljb_lrt.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_all $AVIN $HUMANDB 2> $AVIN.ljb_all.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_phylop $AVIN $HUMANDB 2> $AVIN.ljb_phylop.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_pp2 $AVIN $HUMANDB 2> $AVIN.ljb_pp2.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_sift $AVIN $HUMANDB 2> $AVIN.ljb_sift.log

annotate_variation.pl -buildver hg19 -filter -dbtype ljb_all $AVIN $HUMANDB 2> $AVIN.ljb_all.log

annotate_variation.pl -buildver hg19 -regionanno -dbtype gwascatalog $AVIN $HUMANDB 2> $AVIN.gwascatalog.log

annotate_variation.pl -buildver hg19 -regionanno -dbtype dgv $AVIN $HUMANDB 2> $AVIN.dgv.log 

annotate_variation.pl -buildver hg19 -regionanno -dbtype mce44way $AVIN $HUMANDB 2> $AVIN.mce44way.log 

annotate_variation.pl -buildver hg19 -regionanno -dbtype tfbs $AVIN $HUMANDB 2> $AVIN.tfbs.log 

annotate_variation.pl -buildver hg19 -regionanno -dbtype seggdup $AVIN $HUMANDB 2> $AVIN.segdup.log 

# 
















