#!/usr/bin/perl 
#===============================================================================
#
#         FILE: apt-probeset-genotype.PrepareFormatForClusterPlot.pl
#
#        USAGE: ./apt-probeset-genotype.PrepareFormatForClusterPlot.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 2016년 04월 01일 14시 05분 33초
#     REVISION: ---
#===============================================================================

use strict;

use Getopt::Long;
use Min;
use List::MoreUtils qw/each_array/;
BEGIN { ; }



my $sample;
my $marker;
my $call;
my $summary;
my $output;


GetOptions(
     "s|samples:s"         => \$sample,
     "m|markers:s"         => \$marker,
     "c|call:s"            => \$call,
    "sm|summary:s"         => \$summary,
     "o|output:s"          => \$output,
#    "gs|gene-span:i"     => \$gene_span_size,
#    "sp|splicing-site:i" => \$splicing_site_size,
);

$output = $output || "SignalCluster.txt";
# map { print $_."\n" } ($sample, $marker, $call, $summary, $output);

my %sam    = ToHash( $sample, 1, 1) ;
my %marker = ToHash( $marker, 1, 1) ;

#map { print join "\t", $_, "$sam{$_}\n" } keys %sam;
#map { print join "\t", $_, "$marker{$_}\n" } keys %marker;

# err handler
 get_usage() if !$call;
 get_usage() if !$summary;

my @idx;
my $marker_cnt;

open my $W, '>', $output
  or die "$0 : failed to open output file '$output' : $!\n";
open my $F1, '<', $call
  or die "$0 : failed to open input file '$call' : $!\n";
open my $F2, '<', $summary
  or die "$0 : failed to open input file '$summary' : $!\n";

while (<$F1>) {
    chomp;
	
	my @F;

	if(/^#/){
		next
	}elsif(/^probeset_id/){
		@F = split "\t", $_;
		map {push @idx, $_ if $sam{$F[$_]} } 1 .. $#F;
		## header
		## print "idx", @idx,"\n";
		print $W (join "\t", "probeset_id", @F[@idx]),"\n";
		
		while(<$F2>){
			chomp;
			next if /^#/;
			last if /^probeset_id/;
		}
	}else{
		@F = split "\t", $_, 2;

		my $summary1=<$F2>;
		my $summary2=<$F2>;

		if( $marker{ $F[0] } ){
			$marker_cnt++;
			@F = split "\t", $_;
			my @geno = @F[@idx];

			chmod $summary1;
			chmod $summary2;
			
			my @F1 = (split "\t", $summary1);
			my @F2 = (split "\t", $summary2);
			
			my @A = @F1[@idx];
			my @B = @F2[@idx];

			my @format;
			my $ea = each_array(@geno, @A, @B);
			while( my ($g, $a, $b) = $ea->() ){
				my $x = sprintf ("%.3f", ($a-$b)/($a+$b) );
				my $y = sprintf ("%.3f", log($a+$b) );
				push @format, (join "\|",$g, $x, $y);
			}
			print $W (join "\t", $F[0], @format),"\n";
		}elsif( keys %marker == $marker_cnt ){
			print "marker processing end !\n";
			exit;
		}

	}


}

close $F1
  or warn "$0 : failed to close input file '$call' : $!\n";
close $F2
  or warn "$0 : failed to close input file '$summary' : $!\n";
close $W
or warn "$0 : failed to close output file '$output' : $!\n";


=cut

asdfasfasfasf

=cut 

sub get_usage {
    exec( 'perldoc', $0 );
}


__END__

=head1 NAME


=head1 SYNOPSIS


Usage : apt-probeset-genotype.PrepareFormatForClusterPlot.pl 

	--call AxiomGT1.calls.txt 
	--summary AxiomGT1.summary.txt 
	--sample SAM 
	--marker MARKER 
	--output SignalCluster.txt
	





=head1 DESCRIPTION


apt-probeset-genotype.PrepareFormatForClusterPlot.pl 


=head1 OPTIONS



     "s|samples:s"         => sample list file 
     "m|markers:s"         => marker list file
     "c|call:s"            => calls.txt
    "sm|summary:s"         => summary.txt
     "o|output:s"          => output file ["SignalCluster.txt"]

-
-
-
-


=head2 1.


=head2 2.


=head2 3.


=head2 4.


=head2 5.


=head1 EXSAMPLE


=head1 HISTORY


=cut



