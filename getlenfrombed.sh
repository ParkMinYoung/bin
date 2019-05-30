#!/usr/bin/perl


while(<>){
	@F=split "\t", $_;
	if(@F>=3 && $F[1]=~/\d+/ && $F[2]=~/\d+/){ $s+=$F[2]-$F[1] }
}
print "$s\n";
