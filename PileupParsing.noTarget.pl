#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  PileupParsing.pl
#
#        USAGE:  ./PileupParsing.pl
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
#      CREATED:  05/19/10 16:29:34
#     REVISION:  ---
#===============================================================================

use strict;

use Data::Dumper;
use Getopt::Long;
use Array::IntSpan;
use Set::IntSpan;
use List::Util qw/sum/;

use base qw();
BEGIN { ; }

my ( $in_file,    $out_file,     $target_file );
my ( $in_chr,     $in_start,     $in_end, $in_id ) = ( 1, 2, 3, 4 );
my ( $target_chr, $target_start, $target_end, $target_id ) = ( 1, 2, 3, 4 );
my ( $qscore, ) = ( 34, );

GetOptions(
    "in-file=s"       => \$in_file,
    "out-file=s"      => \$out_file,
    "target-file=s"   => \$target_file,
    "in-chr=i"        => \$in_chr,
    "in-start=i"      => \$in_start,
    "in-end=i"        => \$in_end,
    "in-id=i"         => \$in_id,
    "target-chr=i"    => \$target_chr,
    "target-start=i"  => \$target_start,
    "target-end=i"    => \$target_end,
    "targeti-id=i"    => \$target_id,
    "quality-score=i" => \$qscore,

);

get_usage() if !$in_file;



## set : default out-file
$out_file = $in_file . ".AlleleCnt" unless $out_file;
my @g_type = qw/A C G T I N/;
#################################################################################
my $W_file = $out_file;    # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

#=== READ File Handle ===#
my $F_file = $in_file;     # input file name

open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
    chomp;
    my @F = split /\t/;
    my ( %total, %qc );
    @total{@g_type} = (0) x 6;
    @qc{@g_type}    = (0) x 6;

	$F[8]=~ s/(\^([0-9]|[A-Z]|.)|\$)//g;
        #print $_,"\n";
#       $F[8] =~
#s/(\^([0-9]|\.|,|\*|-|\+)?|\$|!|:|\?|\]|\[|O|F|E|S|Q|>|"|\(|\)|\/|\&|\%|\')//g;
#s/(\^([0-9]|\*|-|\+)?|\$|!|:|\?|\]|\[|O|F|E|S|Q|>|"|\(|\)|\/|\&|\%|\')//g;
        next if $F[2] =~ /\*/;
        if ( length $F[9] != length $F[8] && $F[8] !~ /\+|-/ ) {

            #print length $F[9]," vs ",length $F[8], " $F[8]\n";
            #print "$_\n";
        }
        else {
            my $c = $F[8];
            my @indel;
            if ( $F[8] =~ /\+|\-/ ) {
                while ( $F[8] =~ /([\+\-])(\d\d?)/g ) {
                    my $i   = ( pos $F[8] ) - ( ( length $2 ) + 2 );
                    my $len = ( length $1 . $2 ) + $2 + 1;
                    my $sub = "-" . "I" x ( $len - 1 );
                    push @indel, substr( $c, $i, $len, $sub );
                }
                $c =~ s/\-I+/I/g;
            }
            $c = uc $c;
            $F[2] = uc $F[2];
            $c =~ s/[\,\.]/$F[2]/g;
            my @g = split "", $c;
            my @q = split "", $F[9];

            for my $i ( 0 .. $#q ) {
                $total{ $g[$i] }++;
                if ( ( ord $q[$i] ) - 33 >= $qscore ) {
                    $qc{ $g[$i] }++;
                }
            }
            my @AllVar = grep { $_ if $total{$_} && $_ ne $F[2] } keys %total;
            my @QcVar  = grep { $_ if $qc{$_}    && $_ ne $F[2] } keys %qc;

            my $AllSum = sum @total{@g_type};
            my $QcSum  = sum @qc{@g_type};

            my $AllVarSum = sum( @total{@AllVar} ) || 0;
            my $QcVarSum  = sum( @qc{@QcVar} )     || 0;

            my $AllVarType = ( join ",", @AllVar ) || "-";
            my $QcVarType  = ( join ",", @QcVar )  || "-";

            push @indel, "*" if $total{"*"};
            my %indel;
            @indel{@indel} = ();
            my $InDelType = ( join "\|", keys %indel ) || "-";

            print $W join( "\t",
                @F[ 0 .. 2 ], $AllVarType, @total{@g_type}, $AllSum,
                $AllVarSum,   $QcVarType,  @qc{@g_type},    $QcSum,
                $QcVarSum,    $InDelType ),
              "\n";
        }


}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";
################################################################################

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


Usage : PileupParsing.pl --in-file s_1.bam.sorted.bam.pileup --quality-score 34 --out-file s_1.bam.sorted.bam.pileup.AlleleCnt


 --in-file=s"         input file name
 --out-file=s"        output file name (default: input.out)
 --target-file=s"     target file name (ex: tile)
 --quality-score=i"   quality score threshold


=head1 DESCRIPTION


./PileupParsing.pl  



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



