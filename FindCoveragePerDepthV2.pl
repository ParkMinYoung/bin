#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  FindCoveragePerDepthV2.pl
#
#        USAGE:  ./FindCoveragePerDepthV2.pl
#
#  DESCRIPTION:
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (),
#      COMPANY:
#      VERSION:  1.0
#      CREATED:  03/30/10 12:00:20
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use List::Util qw//;
use Getopt::Long;
use File::Basename;
use Min;

my ( $in_file, $out_file );

GetOptions(
    "in-file=s"  => \$in_file,
    "out-file=s" => \$out_file,
);

if( ! $in_file )
{
	my $s = " "x10;	
	print "\n\n",(fileparse($0))[0]," --in-file infile --out-file outfile\n";
	print "\n$s infile format is bed format\n";
	print "$s outfile format is matrix format\n";
	print "$s outfile default name is infile.depth\n\n\n";
	exit;
}



# default setting
$out_file = "$in_file.depth" unless $out_file;

my $F_file_name = $in_file;
my %dep;
my %m;

open my $F, '<', $F_file_name
  or die "$0 : failed to open  input file '$F_file_name' : $!\n";

while (<$F>) {
    my @F = split "\t",$_,4;

    $dep{ $F[0] }{$_}++ for $F[1] .. $F[2];
}
close $F
  or warn "$0 : failed to close input file '$F_file_name' : $!\n";

my $max_dep = 0;
for my $chr ( keys %dep ) {
    map { $max_dep = $dep{$chr}{$_} if $dep{$chr}{$_} > $max_dep }
      keys %{ $dep{$chr} };
}

for my $chr ( keys %dep ) {
    my $d;
    while (1) {
        $d++;
        my $c = scalar grep { $_ > $d } values %{ $dep{$chr} };
        $m{$d}{$chr} = $c;
        last if $d == $max_dep;
    }

}

mmfsn( $out_file, %m );
