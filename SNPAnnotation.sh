#!/bin/sh 

. ~/.bash_function
#. ~/.perl


HG=hg19
DBSNP=snp150 # all
#DBSNP=snp142Common # freq 1% over 
script=/home/adminrig/src/short_read_assembly/bin/SNPAnnotation.pl

UPSTREAM=5000
DOWNSTREAM=5000


if [ $# -eq 1 ];then


#mysql --user=genome --host=genome-mysql.cse.ucsc.edu -D $HG -A -e'select * from refGene where name="$1"' > $1.txt

echo "mysql --user=genome --host=genome-mysql.cse.ucsc.edu -D $HG -A -e'select * from refGene where name=\"$1\"' > $1.txt" | sh  


perl -F'\t' -anle'if(/^bin/){print}elsif($F[2]!~/_/){print}' $1.txt > $1.txt.bak
mv -f $1.txt.bak $1.txt


perl -F'\t' -asnle'
($chr,$strand, $s,$e)=@F[2,3,4,5]; 
if($.>1){
	if($strand eq "-"){
		$s-=$down;
		$e+=$up;
	}else{
		$s-=$up;
		$e+=$down;
	}
	print join "\t", $chr, $s, $e
}' -- -up=$UPSTREAM -down=$DOWNSTREAM $1.txt > $1.bed
#cut -f3,5,6 $1.txt | grep -v ^chrom > $1.bed

#/home/adminrig/Genome/dbSNP/Mask/hg19.subst.fasta
UCSChg19=/home/adminrig/Genome/hg19Fasta/REF/ucsc.hg19.fasta




fastaFromBed -fi $UCSChg19 -bed $1.bed -fo $1.fasta



perl -F'\t' -anle'
if(@ARGV){
	$strand = $F[3];
	$NM = $F[1];
	$gene = $F[12];
}else{
	if(	/(chr\w+):(\d+)-(\d+)/){
		($chr,$s,$e)=($1,$2+1,$3);
		$pos = "$chr:$s-$e";
		print ">hg19_refGene_$gene range=$pos 5\047pad=0 3\047pad=0 strand=$strand repeatMasking=none";
	}elsif($strand eq "-"){
		tr/ACGTacgt/TGCAtgca/;
		$rev_com=reverse($_);
		print $rev_com;
	}else{
		print;
	}
}
' $1.txt $1.fasta  > $1.input.fasta


#perl -nle'if($.==1){print}else{print uc($_)}' $1.fasta  > tmp
#fastx_reverse_complement -i tmp > $1.fasta
#rm -rf tmp

#fastaFromBed -fi $UCSChg19 -bed $1.bed -fo $1.F.fasta
#fastaFromBed -s antisense-fi $UCSChg19 -bed $1.bed -fo $1.R.fasta 

#cut -c1-50 $1.F.fasta
#cut -c1-50 $1.R.fasta

fasta_formatter -i $1.input.fasta -o $1.fasta -w 50 



#cat $1.bed  | batchUCSC.pl -d $HG -p'$DBSNP:::' > $1.bed.snp
#echo "cat $1.bed  | batchUCSC.pl -d $HG -p'$DBSNP:::' > $1.bed.snp" | sh 
fetchSNP_fromUCSC.sh $1.bed 

perl $script $1.fasta $1.txt $1.bed.snp
mkdir -p RefID/$1 && mv $1.* RefID/$1

else
	usage "$1"
fi

