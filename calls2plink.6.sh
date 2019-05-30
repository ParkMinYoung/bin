
perl -F'\t' -anle'
BEGIN{
	$num{0} = "1 1";
	$num{1} = "1 2";
	$num{2} = "2 2";
	$num{-1} = "0 0";
}

if(@ARGV){
	next if /^Probe/;
	($m,$chr,$bp,$s,$A,$B) = @F[0,2,3,4,8,9];
	if($chr eq "---"){
		($chr, $bp) = (0, 0);
	}
	$chr = 25 if $F[5] + $F[21] > 0;

	@{$h{$m}} = ($chr, $bp);
	if( $s eq "-" ){
		$A=~ tr/ACGT/TGCA/;
		$B=~ tr/ACGT/TGCA/;
	}

	$allele{$m}{A} = $A;
	$allele{$m}{B} = $B;

}else{
		if(/^#/){
			next;
		}elsif(/^probeset/){
			@id = @F[1..$#F];
			map { print STDERR join "\t", $_, $_, 0, 0, 1, 1 } @id;
			$flag=1;
		}elsif($flag && $h{$F[0]}){
			($chr,$bp) = @{$h{$F[0]}};
			
			print join "\t", $chr, $F[0], 0, $bp, (map { $num{$_} } @F[1..$#F]);
		}
}
}{
	$file = "allele.txt";
	open $W, ">", $file or die "$0 Can not open $file $!";
	map { print $W join "\t", $_, 1, 2, $allele{$_}{A}, $allele{$_}{B} } sort keys %allele;
	close $W;
' /home/adminrig/Genome/SNP6.0/GenomeWideSNP_6.na33.annot.csv.tab $1  > $1.tped 2> $1.tfam


plink --tfile $1 --make-bed --out $1.plink
plink --bfile $1.plink --update-alleles allele.txt --make-bed --out $1.plink_fwd

perl -F'\t' -anle'BEGIN{$sex{"male"}=1;$sex{"female"}=2;$sex{"unknown"}=0} if(/^cel_files/){$flag=1}elsif($flag){print join "\t", @F[0,0],$sex{$F[1]};}' birdseed-v2.report.txt > AxiomGT1.report.txt.gender
plink --bfile $1.plink_fwd --update-sex AxiomGT1.report.txt.gender --make-bed --out $1.plink_fwd.gender



#plink --tfile birdseed-v2.calls.txt --make-bed --out 6625
#plink --bfile 6625 --update-alleles allele.txt --make-bed --out 6625_fwd 

#marker sampling (0.5% marker random sampling)
#plink --bfile HEXA_raw  --thin 0.005 --make-bed --out HEXA_raw.sampling

# extract marker
# plink --bfile 6625_fwd --extract HEXA_raw.sampling.SNP --make-bed --out 6625_fwd.sampling --noweb

# HEXA_raw.sampling.SNP
# SNP1
# SNP2

# extract sample
# plink --bfile HEXA_raw.sampling --keep Sample.8 --make-bed --out HEXA_raw.sampling.Sample8 --noweb

# Sample.8 
# A\tA
# B\tB



