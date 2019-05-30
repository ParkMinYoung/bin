perl -F'\t' -anle'
if( /Somatic|LOH|Unknown/ ){
	$k = join "\t", @F[0,1,1],"$F[2]/$F[3]","+";
	$ARGV =~ /(\w+?)\//;
	push @{$h{$k}}, $1;
	push @{$c{$k}}, join "\|", @F[4,5,8,9]; 
	push @{$g{$k}}, join "\|", @F[7,11]; 
}
}{
	map { 
			print join "\t", $_, @{$h{$_}}+0, (join ",", @{$h{$_}}), (join ",", @{$c{$_}}),  (join ",", @{$g{$_}})
			} sort keys %h;

' $@ > MergeVarScanForVEP.input 


## 0       chrom   1
## 1       position        12198
## 2       ref     G
## 3       var     C
## 4       normal_reads1   8
## 5       normal_reads2   11
## 6       normal_var_freq 57.89%
## 7       normal_gt       S
## 8       tumor_reads1    9
## 9       tumor_reads2    4
## 10      tumor_var_freq  30.77%
## 11      tumor_gt        S
## 12      somatic_status  Germline
## 13      variant_p_value 3.5464284535815083E-6
## 14      somatic_p_value 0.9705115184343309
## 15      tumor_reads1_plus       6
## 16      tumor_reads1_minus      3
## 17      tumor_reads2_plus       3
## 18      tumor_reads2_minus      1
## [2] : ################################################################################
## [2] : ################################################################################
## File : [32403389/varscan.output.snp]



## chrom   position        ref     var     normal_reads1   normal_reads2   normal_var_freq normal_gt       tumor_reads1    tumor_reads2    tumor_var_freq  tumor_gt        somatic_status  variant_p_valu
## 1       12659   G       C       23      0       0%      G       21      3       12.5%   S       Somatic 1.0     0.12482269503545868     8       13      2       1
## 1       12672   C       T       19      0       0%      C       21      3       12.5%   Y       Somatic 1.0     0.16400615833401058     8       13      2       1
## 1       14210   G       A       14      5       26.32%  R       8       6       42.86%  R       Germline        1.801878968050816E-4    0.26606293627380123     5       3       5       1
## 1       14610   T       C       32      11      25.58%  Y       22      17      43.59%  Y       Germline        2.2921735016966554E-10  0.06873731270934005     13      9       12      5
## 1       14907   A       G       23      11      32.35%  R       18      16      47.06%  R       Germline        2.925407972058178E-10   0.16079371248162982     12      6       10      6
## 1       14930   A       G       26      14      35%     R       16      17      51.52%  R       Germline        7.920333593588112E-12   0.11842169810239575     14      2       12      5
## 1       15118   A       G       15      5       25%     R       19      7       26.92%  R       Germline        1.0724271534405962E-4   0.5783293219481498      3       16      1       6
## 1       16495   G       C       5       4       44.44%  S       4       5       55.56%  S       Germline        5.16446845701561E-4     0.5000000000000044      4       0       2       3
## 1       16534   C       T       7       3       30%     Y       7       6       46.15%  Y       Germline        7.417426589292693E-4    0.3631040516893282      5       2       4       2
## 
