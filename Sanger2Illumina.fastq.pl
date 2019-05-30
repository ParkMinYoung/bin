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


my @sanger       = ( 33 .. 77 );
my @solexa       = ( 59 .. 126 );
my @illumina_1_3 = ( 64 .. 104 );

my $set_sanger   = new Set::IntSpan \@sanger;
my $set_solexa   = new Set::IntSpan \@solexa;
my $set_illumina = new Set::IntSpan \@illumina_1_3;


while (<>) {
    chomp;
    ## sanger to illumina
    if ( $. % 4 == 0 ) {
        $_ = join "", map { chr( $_ + 31 ) } unpack "C*", $_;
    }
    print "$_\n";
}

## 
# for i in *.gz;do echo "zcat $i | Sanger2Illumina.fastq.pl | gzip -c > $i.sanger2ill.fastq.gz & ";done
##
