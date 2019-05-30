. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

perl -F'\t' -MMin -asnle'
BEGIN{
%h=read_matrix_x($geno)
}


$chr{$F[1]}{$F[0]} = $F[2];

}{ 
 @sample = sort keys %h;
 @marker = sort keys %{$h{$sample[0]}};

 print join "\n", @sample;

for $chr ( keys %chr ){
	open my $F1, ">$chr.ped" || die "$chr.ped cannot open file";
	open my $F2, ">$chr.info" || die "$chr.info cannot open file";

	@chr_marker = sort { $chr{$chr}{$a} <=> $chr{$chr}{$b} } keys %{ $chr{$chr} };
	map { print $F2 join "\t", $_, $chr{$chr}{$_} } @chr_marker;

	for $sam ( @sample ){
		@genotype = map { $h{$sam}{$_} =~ s/(FL|nocall|fail)/NN/i;  $h{$sam}{$_} =~ s/^(\w)/$1 /; $h{$sam}{$_}	} @chr_marker;
		print $F1 join "\t", $sam, $sam, 0, 0, 1, 1, @genotype;
	}

	close $F1;
	close $F2;
}

 ' -- -geno=genotype position

else
 	usage "genotype position"
fi



 ## genotype
 ## 	FMO3rs2266780.A>G	FMO3rs2266782.G>A
 ## 1	AA	GG
 ## 2	AA	GG
 ## 3	AA	GG
 ## 4	GA	GA
 ## 5	AA	GG
 ## 6	AA	GA
 ## 7	GA	GA
 ## 8	AA	GG
 ## 9	GA	GA
 ## 10	FL	FL
 ## 11	GA	GA
 ## 12	GA	AA
 ## 13	AA	GG
 ## 14	GA	GG
 ## 15	GA	GA
 ## 16	GA	GA
 ## 17	AA	GG
 ## 18	AA	GG
 ## 19	AA	GG
 ## 20	AA	GG
 ## 21	AA	GG
 ## 22	AA	GG
 ## 23	AA	GG
 ## 24	GA	AA
 ## 25	AA	GG
 ## 26	AA	GG
 ## 27	AA	GG
 ## 28	AA	GG
 ## 29	AA	GG
 ## 30	AA	GG
 ## 31	AG	AG
 ## 32	AA	GG
 ## 33	AA	GG
 ## 34	AA	AG
 ## 35	AG	AG
 ## 36	AG	AG
 ## 37	AG	AG
 ## 38	AG	AG
 ## 39	AA	GG
 ## 40	AA	GG
 ## 41	AA	GG

## position
 ## FMO3rs2266780.A>G	chr1	1
 ## FMO3rs2266782.G>A	chr1	10
