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
map { print $_."\n" } ($sample, $marker, $call, $summary, $output);

# err handler
 get_usage() if !$call;
 get_usage() if !$summary;

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";
open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
chomp;
	my ( $chr, $s, $e, $geno ) = split /\t/;


}

close $F
or warn "$0 : failed to close input file '$F_file' : $!\n";
close $W
or warn "$0 : failed to close output file '$W_file' : $!\n";

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
            --in-file input.txt 
			[
			 --coord refflat.txt 
			 --format refFlat 
			 --out-file input.txt.out 
			 --ref hg19.fasta 
			 --gene-span 2000 
			 --splicing-site 2
			 ]


    c|coord:s          => coordinate file : refFlat.txt [default v37. refflat]
    f|format:s         => format refFlat|ens|refGene    [default refFlat]
    i|in-file:s        => in file : *.hgXX.SIFT.input
    o|out-file:s       => out file                      [default in_file.out] 
    r|ref:s            => reference fasta file          [default hg19.fasta]
    gs|gene-span:i     => gene span size(up,down stream][default 2000bp]
    sp|splicing-site:i => splicing site size            [defualt 2bp]



=head1 DESCRIPTION


./GetVarAnnotation.pl  



=head1 OPTIONS



-
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



