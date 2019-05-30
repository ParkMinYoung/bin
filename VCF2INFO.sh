#!/bin/sh

perl -F"\t" -MMin -MList::MoreUtils=firstidx -asne'
BEGIN{ @DP = qw/1 5 10 15 20 25 30 50/; }

next if /^#/;

chomp@F;
$k="$F[0]:$F[1]";
$h{$k}{"01.RS"}=$F[2];
$h{$k}{"02.REF"}=$F[3];
$h{$k}{"03.ALT"}=$F[4];
$h{$k}{"04.QUAL"}=$F[5];
$h{$k}{"05.FILTER"}=$F[6];

map { /(\w+)=(.+)/; $h{$k}{"06.$1"}=$2 } split ";", $F[7];

@data=@F[9..$#F];
@l = split ":", $F[8];

$in_DP=firstidx { $_ eq "DP" } @l;
$in_GT=firstidx { $_ eq "GT" } @l;

@depth=map{ ${[split ":", $_]}[$in_DP] } @data;
@GTs=map{ ${[split ":", $_]}[$in_GT] } @data;

map { $h{$k}{"08.$_"} ++ } @GTs;
for $dp ( @depth ){
#print "$dp\n";		
	if( !$dp ){
		$h{$k}{"09.DP0"}++;
		next;
	}

	map { $h{$k}{"09.DP$_"}++ if $dp >= $_ } @DP;
}

}{ mmfss("$f.VcfInfo", %h)' -- -f=$1 $1 
#RSpoint.snp.raw.vcf 


# chr1    171236705       .       C       .       131.80  PASS    AC=0;AF=0.00;AN=470;DP=19916;InbreedingCoeff=-1.0000;MQ=59.80;MQ0=0     GT:DP:GQ:PL     0/0:93:99:0,235,3220    0/0:96:99:0,241,3324


