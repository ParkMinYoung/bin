#!/usr/bin/perl 
#===============================================================================
#
#         FILE: fastqConvert.pl
#
#        USAGE: ./fastqConvert.pl
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
#      CREATED: 08/31/2011 10:50:09 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Set::IntSpan;
use List::MoreUtils qw/uniq firstidx/;
use List::Util qw/min max/;
use IO::Zlib;




## sanger to illumina
# score + 31 
#
## illumina to sanger
# score - 31


my @sanger       = ( 33 .. 77 );
my @solexa       = ( 59 .. 126 );
my @illumina_1_3 = ( 64 .. 104 );

my $set_sanger   = new Set::IntSpan \@sanger;
my $set_solexa   = new Set::IntSpan \@solexa;
my $set_illumina = new Set::IntSpan \@illumina_1_3;

## input file
my $file = $ARGV[0];

## count for test
my $test_cnt = 1000;
my $cnt;
my @all;


## test file for file handle
my $F_file_name = $file;    # input file name

open my $F, '<', $F_file_name
  or die "$0 : failed to open  input file '$F_file_name' : $!\n";
while (<$F>) {
    if ( $. % 4 == 0 ) {
        chomp;
        push @all, unpack "C*", $_;
        last if $test_cnt == ++$cnt;
    }
}

close $F
  or warn "$0 : failed to close input file '$F_file_name' : $!\n";

my @range = sort { $a <=> $b } ( uniq(@all) );
my $min   = min @range;
my $max   = max @range;

#my $ten = firstidx { $_ == 10 } @all;

my $query = [ $min .. $max ];
my $platform;
if ( superset $set_sanger $query ) {
    $platform = "sanger";
}
elsif ( superset $set_illumina $query ) {
    $platform = "illumina";
}
elsif ( superset $set_solexa $query ) {
    $platform = "solexa";
}
else {
    $platform = "else";
}

my $W_file_name = "$file.converted.fastq";    # output file name

open my $W, '>', $W_file_name
  or die "$0 : failed to open  output file '$W_file_name' : $!\n";

my $F1_file_name = $file;                     # input file name

open my $F1, '<', $F1_file_name
  or die "$0 : failed to open  input file '$F1_file_name' : $!\n";

while (<$F1>) {
    chomp;
    ## sanger to illumina
    if ( $. % 4 == 0 ) {
        $_ = join "", map { chr( $_ - 31 ) } unpack "C*", $_;
    }
    print $W "$_\n";
}

close $F1
  or warn "$0 : failed to close input file '$F1_file_name' : $!\n";

close $W
  or warn "$0 : failed to close output file '$W_file_name' : $!\n";

