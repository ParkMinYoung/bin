#!/bin/sh


. ~/.bash_function

if [ $# -eq 4 ];then

#./FakePlink.sh NIH14E9301160 26.73327 4.94319 male

ID=$1
CR=$2
HET=$3
SEX=$4

echo -e "$ID\t$ID\t\t0\t0\t$SEX\t1" > $ID.tfam

perl -MPOSIX -snle'
BEGIN{
$total=833535;
#$marker = sprintf "%.0f", $cr/100*$total;
#$het    = sprintf "%.0f", $het/100*$total;
$marker = ceil($cr/100*$total);
$het    = ceil($het/100*$total);
print STDERR "marker : $marker";
print STDERR "het    : $het";

$het_c++;
$c++;
}

    @F= split /\s+/, $_, 5;

	if( $het_c <= $het && $F[0] <23 ){
		$het_c++;
		$c++;
		print join "\t", @F[0..3], "1 2";
	}elsif( $c <= $marker ){
		print join "\t", @F[0..3], "1 1";
		$c++;
	}else{
		print join "\t", @F[0..3], "0 0";
	}

' -- -cr=$CR -het=$HET /home/adminrig/workspace.min/AFFX/untested_library_files/sample.v2.tped > $ID.tped

plink --tfile $ID --update-alleles /home/adminrig/workspace.min/AFFX/untested_library_files/allele.txt --make-bed --out $ID --noweb
#plink --bfile $ID --missing --out $ID.CR --noweb
#cat $ID.CR.imiss
#cut -f5 $ID.tped | sort | uniq -c
#plink --bfile NIH14E9301160 --recode12 --transpose --out NIH14E9301160.trans --noweb
#awk '{print $5" "$6}' $ID.trans.tped | sort | uniq -c

else
	usage "Sample_ID Call_rate[91.434] Het_rate[15.123] SEX[1 or 2 or 0]"
fi


