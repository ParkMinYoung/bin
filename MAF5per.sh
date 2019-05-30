#!/bin/sh

. ~/.perl
. ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -MMin -ane'
$F[4] =~ /(\w+):/;
$M=length($1);
$F[5] =~ /(\w+):(.+)/;
$m=length($1);
$MAF= $2 > 0.5 ? 1-$2 : $2;

$type = $M+$m ==2 ? "snp" : "indel";

#print "$_\t$MAF\n";


if( $MAF >= 0.05 ){
	chomp $_;
	print join "\t", $_, "$type\n";
}
' $@

else
	echo "vcftools --vcf try.vcf --keep ../JPTandCHB.ind --freq --counts --out try.vcf.out"
	echo "MAF5per.sh try.vcf.out.frq > try.vcf.out.frq.MAF5per.frq"
	usage "try.vcf.out.frq > try.vcf.out.frq.MAF5per.frq"
fi

