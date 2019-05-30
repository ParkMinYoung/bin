#!/bin/sh


if [ -f "$1" ] & [ -f "$2" ] & [ -f "$3" ] & [ -f "$4" ];then

SAMPLE=$1
MARKER=$2
GENOTYPE=$3
SIGNAL=$4

perl -F'\t' -anle'
BEGIN{
$| = 1
}

if(@ARGV==3){
	$sample{$F[0]} = $F[1];
}elsif(@ARGV==2){
	$marker{$F[0]}=$F[1];
}elsif(@ARGV==1){
	next if /^#/;
	if(/^probeset_id/){
		print STDERR "$ARGV is reading.....";

		@sample_header = @F;
		map {push @idx, $_ if $sample{$F[$_]} } 1 .. $#F;
		#print join "\n", @F[@idx];
		print STDERR "sample find : ", @idx+0;
	}elsif($marker{$F[0]}){
		#map { $geno{$F[0]}{$sample_header[$_]} = $F[$_]; print " [$F[0]] [$sample_header[$_]] = [$F[$_]] $geno{$F[0]}{$sample_header[$_]}" } @idx;
		map { $geno{$F[0]}{$sample_header[$_]} = $F[$_] } @idx;
		print STDERR ++$c,"\t$F[0]\r";
	}
}else{
	next if /^#/;
	if(/^probeset/){
		print STDERR "$ARGV is reading.....";

		@sample_header = @F;
		@idx=();
		map { push @idx, $_ if $sample{$F[$_]} } 1 .. $#F;

		#print join "\n", @F[@idx];
		print STDERR "sample find : ", @idx+0;

	}else{
		$F[0]=~/(.+)-(A|B)$/;
		($m,$t) = ($1,$2);
		if( $marker{$m} ){
			map { $intensity{$m}{$sample_header[$_]}{$t} = $F[$_] } @idx;
		}

		if( $marker{$m} && $t eq "B" ){
			print STDERR join "\t", ++$ci, "$m\r";
			#print "marker: $m";
			#print "col : @idx";
			#print "sample : @sample_header[@idx]";
			
			for(  @sample_header[@idx] ){
				
				#X = (A-B)/(A+B) 
				#Y = ln(A+B)

				$X =    ( $intensity{$m}{$_}{A} - $intensity{$m}{$_}{B} ) / ( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} );
				$Y = log( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} );
				
				# split control and case(-5)
				$Y = $sample{$_} == 1 ? $Y : $Y-5;

				print join "\t", $marker{$m}, $_, $geno{$m}{$_}, $X, $Y;
			}

			#map { print join "\t", $m, $_, $geno{$m}{$_}, "( $intensity{$m}{$_}{A} - $intensity{$m}{$_}{B} ) / ( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} ), log(  $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} ) " }  @sample_header[@idx];
		}
	}
}

' $SAMPLE $MARKER $GENOTYPE $SIGNAL > ClusterSignal.txt

perl `which create_cluster_new.pl` ClusterSignal.txt

#' CelList.CaseControl MarkerList AxiomGT1.calls.txt AxiomGT1.summary.txt > ClusterSignal.txt

else
	echo "$0 CEL_FILELIST MARKER_FILELIST XXX.calls.txt XXX.summary.txt"
fi


