#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  MakeLaneSequence.pl
#
#        USAGE:  ./MakeLaneSequence.pl
#
#  DESCRIPTION:  make SGE batch script : s_lane_frag_tile_qseq.txts file
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (),
#      COMPANY:
#      VERSION:  1.0
#      CREATED:  03/22/10 12:26:14
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

=cut

use File::Basename;
use Getopt::Long;

if ( $#ARGV < 0 ) {
    print STDERR <<EOF;

Usage 
$0 

Options:
--pair1 <paired fastq 1>      Required.
--pair2 <paired fastq 2>      Required.
--pair-index <index fastq>    Required.
--output-dir <default ./>
EOF
    exit(1);
}

my ( $pair1, $pair2, $index );
my ($output_dir) = ("./");
my $run_id;

GetOptions(
    'pair1=s'      => \$pair1,
    'pair2=s'      => \$pair2,
    'pair-index=s' => \$index,
    'output-dir=s' => \$output_dir,
);
	  
=cut

my @tile=1..120;
my @lane=8;
my $read=1;
my $fir_cycle=1;
my $max_cycle=100;
my $basecall_dir=$ENV{PWD};
#my $inst="HWUSI-EAS052R";
my $inst="ILLUMINA-CD89F7";
#my $runid="00006";
my $runid="00002";

for my $lane( @lane)
{
	for my $tile( @tile )
	{
		my $fix_tile = sprintf "%04s",$tile;
		my $filterfile="$basecall_dir/s_".$lane."_".$fix_tile.".filter";
		my $posfile="$basecall_dir/../s_".$lane."_".$fix_tile."_pos.txt";
		my $qseqfile="s_".$lane."_1_".$fix_tile."_qseq.txt"	;
		my $cmd = "/home/adminrig/src/SolexaSrc/1.7.0/BclConverter-1.7.1/bin/bclToQseq --lane $lane --tile $tile --read $read --repeat 1 --first-cycle $fir_cycle --number-of-cycles $max_cycle --input-directory $basecall_dir --instrument $inst --run-id $runid --filter-file $filterfile --positions-file $posfile --qseq-file $qseqfile\n";
		print $cmd;
	}
}
	  

