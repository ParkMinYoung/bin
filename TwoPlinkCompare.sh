#!/bin/sh

. ~/.bash_function

if [ -f "$1.bim" ] & [ -f "$2.bim" ];then


		perl -F"\t" -anle'print join "\t",$F[0], $F[3], sort(@F[4,5])' $1.bim | sort | uniq > $1.bim.u
		perl -F"\t" -anle'print join "\t",$F[0], $F[3], sort(@F[4,5])' $2.bim | sort | uniq > $2.bim.u
		cat $1.bim.u $2.bim.u | sort | uniq -d >  Common


		perl -F"\t" -anle'$k=join "\t", @F[0,3], sort(@F[4,5]);  if(@ARGV){$h{$_}++}elsif( $h{$k} ){ print }' Common $2.bim | grep -v AF |  cut -f2 > $2.bim.Marker
		perl -F"\t" -anle'$k=join "\t", @F[0,3], sort(@F[4,5]);  if(@ARGV){$h{$_}++}elsif( $h{$k} ){ print }' Common $1.bim | grep -v AF |  cut -f2 > $1.fam.Marker


		~/src/PLINK/plink-1.09-x86_64/plink --bfile $1 --extract $1.fam.Marker --make-bed --out $1.extract --allow-no-sex --threads 20
		~/src/PLINK/plink-1.09-x86_64/plink --bfile $2 --extract $2.bim.Marker --make-bed --out $2.extract --allow-no-sex --threads 20


		perl -F'\t' -i.bak -aple'$F[1]=join ":", $F[0],$F[3],sort(@F[4,5]); $_=join "\t", @F' $2.extract.bim
		perl -F'\t' -i.bak -aple'$F[1]=join ":", $F[0],$F[3],sort(@F[4,5]); $_=join "\t", @F' $1.extract.bim

		/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $1.extract --bmerge $2.extract.{bed,bim,fam} --genome --min 0.8 --out merge.out --allow-no-sex --threads 20
		PlinkOut2Tab.sh merge.out.genome
		OrderedValueListFromKey.sh 3 1 10 merge.out.genome.tab


else
		usage "PlinkA PlinkB"
fi

