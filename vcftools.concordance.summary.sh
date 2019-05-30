
perl -F'\t' -MMin -anle'
if($ARGV=~/diff.sites$/){
	$k = join "\t", @F[-5,-4,-3,-2];
	$match_type{$k}++;
	$diff_sites++;
}elsif($ARGV=~/diff.sites_in_files$/){
	$int{$F[2]}++;
	$diff_sites_in_files++;
}elsif($ARGV =~ /log$/){
	push @snp, $1 if /File contains (\d+) entries and 1 individuals/;
}elsif( $ARGV =~ /.diff.discordance_matrix$/){
	if(/^N_0\/0/ ){
		push @match, $F[1];
		push @non_match, @F[2,3];
	}elsif(/^N_0\/1/){
		push @match, $F[2];
		push @non_match, @F[1,3];
	}elsif(/^N_1\/1/){
		push @match, $F[3];
		push @non_match, @F[1,2];
	}
	$sum= sum(@F[1..4]);
	push @matrix, "$_\t$sum"; 
}


}{

$snp_1 = $snp[0];
$snp_2 = $snp[1];

$filter_1_uniq = $int{1};
$filter_2_uniq = $int{2};
$intersect = $int{B};

$diff_geno = $diff_sites_in_files - $diff_sites;

$match = sum(@match);
$mismatch = sum(@non_match);
$sum = $match + $mismatch;


$not_matching_allele = $match_type{"B\t0\t1\t0"} + $match_type{"B\t0\t1\t1"};   ## allele not match, but genotype same or not
$discordant = $match_type{"B\t0\t1\t1"} + $match_type{"B\t1\t1\t1"};

$dis_per = sprintf "%0.2f",  $discordant/($intersect - $diff_geno)*100;
$mismatch_rate = sprintf "%0.2f",  $mismatch/$sum*100;

print join "\t", qw/title uniq1 intersect uniq2 /;
print join "\t", "raw SNV", $snp_1, "", $snp_2;
print join "\t", "filterd SNV", $filter_1_uniq+$intersect, "", $intersect+$filter_2_uniq;
print join "\t", "intersect", $filter_1_uniq, $intersect, $filter_2_uniq;
print join "\t", "intersect detail", "", $intersect - $diff_geno, $diff_geno, "#not matching ref allele";

print "\n\n";
print join "\n", @matrix;
print "\n\n";
print join "\t", "summary", "match","mismatch","sum" ,"mismatch rate", "not_matching_var_allele";
print join "\t", "count", $match, $mismatch, $sum, $not_matching_allele, $mismatch_rate, "# comparable, but var allele is different and genotype is same or not";

print "\n\n";
print join "\t" , qw/DisSummary possible_cmp discordant_N discordant_P/;
print join "\t", "count", $intersect - $diff_geno, $discordant, $dis_per;

print "\n\n";
map { print join "\t", $_, $match_type{$_} } sort keys %match_type;

print "\n";

' $@ 

