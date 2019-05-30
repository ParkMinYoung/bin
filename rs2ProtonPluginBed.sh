
DATE=$(date +%Y%m%d)

RsFinder.sh $1


perl -F'\t' -anle'
BEGIN{
print "track name=\"DNAGPS chip 6.0\" description=\"DNAGPS chip 6.0 hotspots\" type=bedDetail";
}
if($F[1]!~/_/ && $F[11] eq "single" && length($F[7])==1 && !/insertion/ ){
				

	$cosm="COSM".++$c;
	$F[9] =~ tr/ACGT/TGCA/ if $F[6] eq "-";

	%h=();
	map { $h{$_}++ }split /\//, $F[9];
	delete $h{$F[7]};
	($ALT) = keys %h;

	print join "\t", @F[1,2,3],$cosm,"0","+","REF=$F[7];OBS=$ALT;ANCHOR=$F[7]",$F[4];
}' $1.output > $1.output.bed


