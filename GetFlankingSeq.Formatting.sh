#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then

		DEFAULT=250
		len=$3
		LEN=${len:=$DEFAULT}

		perl -F'\t' -MMin -asnle'
		BEGIN{%iupac=iupac2geno()}
		if(@ARGV){
			$s=$F[2]-$len;
			$e=$F[3]+$len;
			$id="$F[1]:$s-$e";
			$F[9]=~tr/ACGTacgt/TGCAtgca/ if $F[6] eq "-";
			$h{$id}="$F[4],$F[9]";
		}elsif($h{$F[0]}){
			$F[1]=uc $F[1];
			($rs,$allele)= split ",", $h{$F[0]};
			$left=substr $F[1], 0, $len;
			$right=substr $F[1],$len+1, $len;
			$iupac=substr $F[1],$len,1;
#$geno= join "\/", split "", $iupac{$allele};
			print join "\t", $rs, $left, $allele, $right, $iupac
		}else{
			die
		}' -- -len=$LEN $1 $2 > $2.flankseq

else
		usage "rs.list.20110708.dbsnp rs.list.20110708.dbsnp.bed.span100.bed.fasta [Length : 100]"
fi

# chr1:207814350-207814551	TACTTAAAAATTAAAGACCAAACTTCTCTCCACCCAACAAAAATGGGCAAAGGACATACAGCTAGGTCACCAAGAAAGAAGGGCAAATAGGTGGTGAGTAYATGTAAAGATACTTGATAGGACTTTTGCTTAGTTGAATCTTTAGCAAATCTCTTTTATTTCTTGGGATTTTGAAGAAGTAATTTTTAAAGGAGGACTAGA
# head rs.list.20110708.dbsnp.bed.span100.bed
# chr1	22421012	22421213	rs12740705

 ## 0       585     585
 ## 1       chr1    chr1
 ## 2       10326   10439
 ## 3       10327   10440
 ## 4       rs112750067     rs112155239
 ## 5       0       0
 ## 6       +       +
 ## 7       T       C
 ## 8       T       C
 ## 9       C/T     A/C
 ## 10      genomic genomic
 ## 11      single  single
 ## 12      unknown unknown
 ## 13      0       0
 ## 14      0       0
 ## 15      unknown unknown
 ## 16      exact   exact
 ## 17      1       1
 ## 18
 ## 19      1       1
 ## 20      BCM-HGSC-SUB,   BCM-HGSC-SUB,
 ## 21      0       0
 ## 
