#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  AlleleCnt2bed.pl
#
#        USAGE:  ./AlleleCnt2bed.pl
#
#  DESCRIPTION:
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Min Young Park (mn), minmin@dnalink.com
#      COMPANY:  DNALink.inc
#      VERSION:  1.0
#      CREATED:  05/23/10 15:06:31
#     REVISION:  ---
#===============================================================================

use strict;

use Data::Dumper;
use Getopt::Long;

use Array::IntSpan;
use Set::IntSpan;

use base qw();
BEGIN { ; }

my ( $in_file,    $out_file,     $out_bed );
my ( $in_chr,     $in_start,     $in_end, $in_id ) = ( 1, 2, 3, 4 );
my ( $target_chr, $target_start, $target_end, $target_id ) = ( 1, 2, 3, 4 );

GetOptions(
    "in-file=s"  => \$in_file,
    "out-file=s" => \$out_file,
    "out-bed=s"  => \$out_bed,
);

## set : default out-file
$out_file = $in_file . ".var"     unless $out_file;
$out_bed  = $in_file . ".var.bed" unless $out_bed;

my $W_file = $out_file;    # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

my $W1_file = $out_bed;    # output file name

open my $W1, '>', $W1_file
  or die "$0 : failed to open output file '$W1_file' : $!\n";

#################################################################################
#=== READ File Handle ===#
my $F_file = $in_file;     # input file name

open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
    chomp;
    my @F = split /\t/;

    if ( $F[19] && $F[20] ) {
        my $ratio = sprintf "%0.4f", $F[20] / $F[19] * 100;
        if ($ratio) {
            print $W "$_\n";
            print $W1 join( "\t",
                $F[0], $F[1] - 1,
                $F[1], ( join " / ", $F[2], $F[12], $F[19], $F[20], $ratio) ),
              "\n";
        }
    }
}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";
#################################################################################

close $W1
  or warn "$0 : failed to close output file '$W1_file' : $!\n";

close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";

sub new {
    my $class = shift;
    my $self  = {@_};
    bless $self, $class;
}

sub get_usage {
    exec( 'perldoc', $0 );
}

__END__

=head1 NAME


=head1 SYNOPSIS


Usage : AlleleCnt2bed.pl  

--in-file=s"         input file name
--out-file=s"        output file name (default: input.out)
--target-file=s"     target file name (ex: tile)

--in-chr=i"          input file chr column
--in-start=i"        input file start column
--in-end=i"          input file end column
--in-id=i"           input file id column

--target-chr=i"      target file chr column
--target-start=i"    target file start column
--target-end=i"      target file end column
--targeti-id=i"      target file id column



=head1 DESCRIPTION


./AlleleCnt2bed.pl  



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



