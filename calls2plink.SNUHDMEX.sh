
perl -F'\t' -anle'
BEGIN{
	$num{0} = "1 1";
	$num{1} = "1 2";
	$num{2} = "2 2";
	$num{-1} = "0 0";
}

if(@ARGV){
	next if /^Probe/;
	($m,$chr,$bp,$s,$A,$B) = @F[0,4,5,7,11,12];
	($x1, $x2) = @F[8,24];

	if($chr eq "---"){
		($chr, $bp) = (0, 0);
	}
	$chr = 25 if $x1 + $x2 > 0;

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
' $2 $1  > $1.tped 2> $1.tfam


plink --tfile $1 --make-bed --out $1.plink --noweb

plink --bfile $1.plink --update-alleles allele.txt --make-bed --out $1.plink_fwd --noweb

perl -F'\t' -anle'BEGIN{$sex{"male"}=1;$sex{"female"}=2;$sex{"unknown"}=0} if(/^cel_files/){$flag=1}elsif($flag){print join "\t", @F[0,0],$sex{$F[1]};}' AxiomGT1.report.txt > AxiomGT1.report.txt.gender
#perl -F'\t' -anle'BEGIN{$sex{"male"}=1;$sex{"female"}=2;$sex{"unknown"}=0} if(/^cel_files/){$flag=1}elsif($flag){ /(NIH\w+)\.CEL/; print join "\t", $1,$1,$sex{$F[1]};}' AxiomGT1.report.txt > AxiomGT1.report.txt.gender
plink --bfile $1.plink_fwd --update-sex AxiomGT1.report.txt.gender --make-bed --out $1.plink_fwd.gender --noweb

plink --bfile $1.plink_fwd.gender --out $1.plink_fwd.gender.count --freq --counts --noweb
perl -F'\s+' -anle'next if $.==1; shift@F;$CR = sprintf "%.2f", (1 - ( $F[6] /( ($F[4]+$F[5])/2 + $F[6] ) ))*100; print join "\t", $F[1], $CR ' $1.plink_fwd.gender.count.frq.count > $1.plink_fwd.gender.count.frq.count.CR



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



