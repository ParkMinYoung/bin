#!/bin/sh

source ~/.bash_function

if [ $# -ge 2 ] & [ -f "$1" ];then
	
	# VCF2EachSamplesVCF.sh $1
	# for i in `ls $1.*vcf`;do echo $i;done
	
	I_DB=$3
	DB=${I_DB:="hg19"}

	perl -F'\t' -MList::MoreUtils=uniq -asnle'
	BEGIN{
			$type="pgSnp";
			$visibility=3;
			print "track type=$type visibility=$visibility db=$db name=\"$sample\" description=\"$sample\""
	}
	next if /^#/;
	$s=$F[1]-1;
	next if $F[9] eq "./.";
	@GT=split ":",$F[9];
	@num = uniq ( split "\/", $GT[0] );
	$AC = @num;
	$geno=join "\/", map { $F[$_+3] } @num;
	print join "\t", $F[0],$s,$F[1],$geno,$AC,$GT[1],(join ",",(0)x$AC);
	
	' -- -db=$DB -sample=$2 $1
else
	usage "XXX.vcf sampleID [db(hg19)]"
fi
