#!/bin/sh


if [ -f "$1" ] & [ -f "$2" ] & [ -f "$3" ] & [ -f "$4" ];then

 ## SAMPLE=$1
 ## MARKER=$2
 ## GENOTYPE=$3
 ## SIGNAL=$4

perl -nle'
BEGIN{
$| = 1
}
@F = split "\t", $_, 3;
if($ARGV =~ /Sample/i || @ARGV == 3 ){
	$sample{$F[0]} = $F[1] || $F[0];
	#print STDERR "$ARGV is reading";
}elsif($ARGV =~ /Marker/i || @ARGV == 2){
	$marker{$F[0]}=$F[1] || $F[0];
	#print STDERR "$ARGV is reading";
}elsif($ARGV =~ /calls.txt$/){
	next if /^#/;
	if(/^probeset_id/){
		@F= split "\t", $_;
		print STDERR "$ARGV is reading.....";

		@sample_header = @F;
		map {push @idx, $_ if $sample{$F[$_]} } 1 .. $#F;
		#print join "\n", @F[@idx];
#		print STDERR "sample find : ", @idx+0;
	}elsif($marker{$F[0]}){
		@F= split "\t", $_;
		#map { $geno{$F[0]}{$sample_header[$_]} = $F[$_]; print " [$F[0]] [$sample_header[$_]] = [$F[$_]] $geno{$F[0]}{$sample_header[$_]}" } @idx;
		map { $geno{$F[0]}{$sample_header[$_]} = $F[$_] } @idx;
#		print STDERR ++$c,"\t$F[0]";
	}
}elsif($ARGV =~ /summary.txt$/){
	next if /^#/;
	if(/^probeset/){
		@F= split "\t", $_;
#		print STDERR "$ARGV is reading.....";

		@sample_header = @F;
		@idx=();
		map { push @idx, $_ if $sample{$F[$_]} } 1 .. $#F;

		#print join "\n", @F[@idx];
#		print STDERR "sample find : ", @idx+0;

	}else{
		$F[0]=~/(.+)-(A|B)$/;
		($m,$t) = ($1,$2);
		if( $marker{$m} ){
			@F= split "\t", $_;
			map { $intensity{$m}{$sample_header[$_]}{$t} = $F[$_] } @idx;
		}

		if( $marker{$m} && $t eq "B" ){
#			print STDERR join "\t", ++$ci, "$m\r";
			#print "marker: $m";
			#print "col : @idx";
			#print "sample : @sample_header[@idx]";
			
			for(  @sample_header[@idx] ){
				
				#X = (A-B)/(A+B) 
				#Y = ln(A+B)

				$X = sprintf "%.4f",  ( $intensity{$m}{$_}{A} - $intensity{$m}{$_}{B} ) / ( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} );
				$Y = sprintf "%.4f", log( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} );
				
				# split control and case(-5)
				# $Y = $sample{$_} == 1 ? $Y : $Y-5;
				
				if( ! $sam{$_} ){
					$sam{$_} = ++$count;
				}


				print join "\t", $marker{$m}, $sam{$_}, $geno{$m}{$_}, $X, $Y;
			}

			#map { print join "\t", $m, $_, $geno{$m}{$_}, "( $intensity{$m}{$_}{A} - $intensity{$m}{$_}{B} ) / ( $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} ), log(  $intensity{$m}{$_}{A} + $intensity{$m}{$_}{B} ) " }  @sample_header[@idx];
		}
	}
}

' $@ > ClusterSignal.txt

# perl `which create_cluster_new.pl` ClusterSignal.txt

#' CelList.CaseControl MarkerList AxiomGT1.calls.txt AxiomGT1.summary.txt > ClusterSignal.txt

else
	echo "$0 CEL_FILELIST MARKER_FILELIST XXX.calls.txt XXX.summary.txt"
fi


