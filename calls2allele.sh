perl -F'\t' -anle'
next if $. == 1;
	($m,$chr,$bp,$s,$A,$B) = @F[0,2,3,4,8,9];
	@{$h{$m}} = ($chr, $bp);
	if( $s eq "-" ){
		$A=~ tr/ACGT/TGCA/;
		$B=~ tr/ACGT/TGCA/;
	}

	print join "\t", $m, 1, 2, $A, $B
' /home/adminrig/Genome/SNP6.0/GenomeWideSNP_6.na33.annot.csv.tab > allele.txt 

#plink --tfile birdseed-v2.calls.txt --make-bed --out 6625
#plink --bfile mydata --update-alleles mylist.txt --make-bed --out newfile 

