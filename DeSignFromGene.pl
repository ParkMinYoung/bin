#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  DeSignFromGene.pl
#
#        USAGE:  ./DeSignFromGene.pl
#
#  DESCRIPTION:  NGS Design from Gene list
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Min Young Park (mn), minmin@dnalink.com
#      COMPANY:  DNALink.inc
#      VERSION:  1.0
#      CREATED:  05/25/09 14:58:46
#     REVISION:  ---
#===============================================================================

use strict;

use Data::Dumper;
use Getopt::Std;
use Min qw/hash_tab_limited_cnt/;

use Set::IntSpan;
#use Array::IntSpan;

BEGIN { ; }

my %args;

getopt( "i:d:p:e:t:", \%args );

die get_usage() unless $args{i};
die get_usage() unless $args{d};

#####################################################
## Config
my %result;    ## result hash

my $promoter = $args{p} || 0;    ## promoter size
my $exon_pad = $args{e} || 0;      ## exon pad size
my $down     = $args{t} || 0;
print << "CFG";
promoter size      : $promoter
exon padding size  : $exon_pad
down stream size   : $down
CFG

#####################################################

## Gene List ##
my %Gene = hash_tab_limited_cnt( $args{i}, 1, 1 );

## library file name
my $F_file = $args{d};    # input file name

open my $F, '<', $F_file
  or die "$0 : failed to open  input file '$F_file' : $!\n";

while (<$F>) {
    chomp;
    my @F = split /\t/;

    ## wanted gene
    if ( $Gene{ $F[0] } ) {
        $Gene{ $F[0] }++;

        my @s = split ",", $F[9];
        my @e = split ",", $F[10];

        ## exon region position
        my @array = map { [ $s[$_], $e[$_] ] } 0 .. $F[8] - 1;

        if ( not defined $result{ $F[2] }{ $F[0] }{span} ) {

            #         chr     gene
            $result{ $F[2] }{ $F[0] }{span}   = new Set::IntSpan \@array;
            $result{ $F[2] }{ $F[0] }{strand} = $F[3];
        }
        else {
            $result{ $F[2] }{ $F[0] }{span}->U( \@array );
        }

        push @{ $result{ $F[2] }{ $F[0] }{list} }, $_;
    }
}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";

#####################################################
## out, refFlat check
my $W_file = "$args{i}.out";    # output file name

my $W2_file = "$args{i}.refFlat";    # output file name

open my $W2, '>', $W2_file
  or die "$0 : failed to open  output file '$W2_file' : $!\n";

open my $W, '>', $W_file
  or die "$0 : failed to open  output file '$W_file' : $!\n";
for my $chr ( sort keys %result ) {
    for my $gene ( sort keys %{ $result{$chr} } ) {
        my $obj = $result{$chr}{$gene}{span};
        my $pad = pad $obj $exon_pad;

		my $min = min $pad;
		my $max = max $pad;
        
		if ( $result{$chr}{$gene}{strand} eq "+" ) {
            $pad->U( [ [ $min + $exon_pad - $promoter, $min + $exon_pad ] ] );
            $pad->U( [ [ $max - $exon_pad, $max - $exon_pad + $down     ] ] );
        }
        else {
            $pad->U( [ [ $min + $exon_pad - $down, $min + $exon_pad ] ] );
            $pad->U( [ [ $max - $exon_pad, $max - $exon_pad + $promoter ] ] );
        }

        my @spans = spans $pad;

        for (@spans) {
            print $W join( "\t", $gene, $chr, @{$_}, $_->[1] - $_->[0] + 1 ), "\n";
        }


		for my $ref ( @{ $result{$chr}{$gene}{list} } )
		{
			print $W2 "$ref\n";
		}
    }
}

close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";

close $W2
  or warn "$0 : failed to close output file '$W2_file' : $!\n";

#####################################################
## NoGene Check

my $W1_file = "$args{i}.noGene";    # output file name

open my $W1, '>', $W1_file
  or die "$0 : failed to open  output file '$W1_file' : $!\n";

for ( keys %Gene ) {
    if ( $Gene{$_} == 1 ) {
        print $W1 "$_\n";
    }
}

close $W1
  or warn "$0 : failed to close output file '$W1_file' : $!\n";

#####################################################

sub get_usage {
    exec( 'perldoc', $0 );
}

__END__

=head1 NAME
 
 DeSignFromGene.

=head1 SYNOPSIS

Usage : DeSignFromGene.pl -i GeneListFile -d refFlat.txt -p 2000 -e 50 -t 500

db format refFlat.txt
	
	1  UGT1A10

	2  NM_019075

	3  chr2

	4  +

	5  234209861

	6  234346690

	7  234209907

	8  234345944

	9  5

	10  234209861,234340418,234341233,234341604,234345646,

	11  234210762,234340550,234341321,234341824,234346690,

=head1 DESCRIPTION

./DeSignFromGene.pl  
 Design NGS exon capturing array


=head1 OPTIONS
	
	-i	input file   : GeneSymbol per row
	-d	library file : refFlat.txt file 
	-p	promoter     : bp size
	-e	exon padding : bp size
	-t	downstream   : bp size

=head2 1.

=head2 2.

=head2 3.

=head2 4.

=head2 5.

=head1 EXSAMPLE

=head1 HISTORY

=cut



