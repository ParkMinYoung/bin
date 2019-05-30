#!/bin/sh


if [ -f "$1" ] & [ -f "$2" ] & [ -f "$3" ] ;then

SAMPLE=$1
MARKER=$2
GENOTYPE=$3

OUT=$(basename $GENOTYPE).$(basename SAMPLE).sam.mark

perl -F'\t' -anle'
BEGIN{
$| = 1
}

chomp@F;

if(@ARGV==2){
	$sample{$F[0]} = $F[1] || $F[0];
}elsif(@ARGV==1){
	#$marker{$F[0]}++;
	$marker{$F[0]}=$F[1] || $F[0];
}else{
	next if /^#/;
	if(/^probeset/){
		@sample_header = @F;
		map { push @idx, $_ if $sample{$F[$_]} } 1 .. $#F;
		print STDERR "Sample finding : ", @idx+0;
		@id =  @F[@idx];

		print join "\t", "probeset_id", @sample{@id};
	}elsif($marker{$F[0]}){
		print join "\t", $marker{$F[0]}, @F[ @idx ];
		#print join "\t", $marker{$F[0]}, ( map { $geno{$F[0]}{$sample_header[$_]} = $F[$_] } @idx );
		#print join "\t", $marker{$F[0]}, ( map { $geno{$F[0]}{$sample_header[$_]} = $F[$_] } @idx );
	}
}

' $SAMPLE $MARKER $GENOTYPE > $GENOTYPE.extract 


else
	echo "$0 CEL_FILELIST MARKER_FILELIST XXX.calls.txt"
fi


