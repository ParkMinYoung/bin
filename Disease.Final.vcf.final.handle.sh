


perl -F"\t" -MList::MoreUtils=natatime -asnle'next if $.==1;
$line=$_;
@data=@F[5 .. $#F];
$sam=@data/4;
@geno=();
$it = natatime $sam, @data;
while (@vals = $it->()){
	push @geno, [@vals]
}
$dp = @dp = grep { $_ >= $DP } @{$geno[2]};
$gq = @gq = grep { $_ >= $GQ } @{$geno[3]};
if($dp >= 4 && $gq >= 4 ){
	print "$line\t$dp\t$gq";
} ' -- -DP=10 -GQ=50 Disease.Final.vcf.final > Disease.Final.vcf.final.DP10GQ50
