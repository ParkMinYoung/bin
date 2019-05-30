#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  MakeLaneSequence.pl
#
#        USAGE:  ./MakeLaneSequence.pl
#
#  DESCRIPTION:  make lane sequence from bustard s_lane_frag_tile_qseq.txts
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

use File::Basename;
use Getopt::Long;

if ( $#ARGV < 0 ) {
    print STDERR <<EOF;

Usage 
$0 --single s_1_1_0001_qseq.txt [ --output-dir ./ ]

Options:
--single     <paired fastq 1>      Required.
--output-dir <default ./>
EOF
    exit(1);
}

my ( $single, );
my ($output_dir) = ("./");
my $run_id;

GetOptions(
    'single=s'      => \$single,
    'output-dir=s' => \$output_dir,
);

mkdir $output_dir unless -d $output_dir;
$output_dir .= "/" if $output_dir !~ /\/$/;

my ( $p1_name, $p1_dir ) = fileparse $single;

my $lane_tile;

if ( $single =~ /(s_\d+)_\d+_(\d{4})/ ) {
    $lane_tile = $1 . "_" . $2;
}

for my $file ( $single,) {
    die "$file do not exist\n!" unless -e $file;
}

my $F1_file_name = $single;    # output file name
open my $F1, '<', $F1_file_name
  or die "$0 : failed to open  output file '$F1_file_name' : $!\n";

my $W1_file_name = $output_dir . "$lane_tile.1.fastq";    # input file name

open my $W1, '>', $W1_file_name
  or die "$0 : failed to open  input file '$W1_file_name' : $!\n";

while (<$F1>) {
    my $p1 = $_;

    chomp( $p1, );

    my @p1 = split "\t", $p1;
	
	$p1[8] =~ s/\./N/g;

	next unless $p1[-1]; ## filter out is next

    unless ($run_id) {
        $run_id = sprintf "%04s", $p1[1];
    }

    my $line = $p1[0]."_". join( ":", $run_id, @p1[ 2 .. 5 ] ). "#1";

    print $W1 ( join "\n", "@" . $line . "/1", $p1[8], "+" . $line . "/1",
        $p1[9] ), "\n";
}

close $F1
  or warn "$0 : failed to close output file '$F1_file_name' : $!\n";



close $W1
  or warn "$0 : failed to close input file '$W1_file_name' : $!\n";

