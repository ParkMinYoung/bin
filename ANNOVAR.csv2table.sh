csv2tab.sh $1 > $1.tab


perl -F'\t' -MList::MoreUtils=uniq -anle'

if( $. == 1){
	print join "\t", qw/Gene ExonicFunc AAChage ESP6500_ALL 1000g2012apr_ALL dbSNP137 SIFT PolyPhen2 MutationTaster PhyloP Chr Start End Ref Obs/
}else{

$F[1] = join ";", uniq(split ";", $F[1]);

my $phylop_score = sprintf "%.3f", $F[10];
my $phylop = "$F[11] ($phylop_score)" if $F[11];

my $sift_score = sprintf "%.3f", $F[12];
my $sift = "$F[13] ($sift_score)" if $F[13];

my $pp2_score = sprintf "%.3f", $F[14];
my $pp2 = "$F[15] ($pp2_score)" if $F[15];

my $mt_score = sprintf "%.3f", $F[18];
my $mt = "$F[19] ($mt_score)" if $F[19];

$F[6] = sprintf "%.3f", $F[6] if $F[6] ;
$F[7] = sprintf "%.3f", $F[7] if $F[7] ;

print join "\t", @F[1,2,3,6,7,8], $sift, $pp2, $mt, $phylop, @F[21..25];

}' $1.tab > $1.tab.table

