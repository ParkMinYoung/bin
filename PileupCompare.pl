#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  PileupCompare.pl
#
#        USAGE:  ./PileupCompare.pl
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
#      CREATED:  01/05/11 13:22:08
#     REVISION:  ---
#===============================================================================

use strict;

#use Data::Dumper;
#use Getopt::Std;
use Getopt::Long;

#use Array::IntSpan;
#use Set::IntSpan;

use base qw();
BEGIN { ; }

my ( $a_file, $b_file );
my ( $out_file, $interval ) = ( "variation.txt", 1000000 );

GetOptions(
    "a=s"        => \$a_file,
    "b=s"        => \$b_file,
    "out-file=s" => \$out_file,
    "interval=i" => \$interval,
);

get_usage() if ! $a_file;
get_usage() if ! $b_file;
get_usage() if ! -f $a_file || ! -f $b_file;

#################################################################################
#=== READ File Handle ===#
my $FIR_file = $a_file;    # input file name

#=== READ File Handle ===#
my $SEC_file = $b_file;    # input file name

open my $FIR, '<', $FIR_file
  or die "$0 : failed to open input file '$FIR_file' : $!\n";

open my $SEC, '<', $SEC_file
  or die "$0 : failed to open input file '$SEC_file' : $!\n";

my ( $F_prepos, $S_prepos ) = ( 0, 0 );
my ( @F_pre, @S_pre );
while (1) {
    my $F = <$FIR>;
    my $S = <$SEC>;
	my (@F,@S);
    @F = split /\t/, $F if $F;
    @S = split /\t/, $S if $S;

	last if !@F;
	last if !@S;

    ## chr is same
    if ( $F[0] eq $S[0] ) {
        ## fir.pos > sec.pos
        if ( $F[1] > $S[1] ) {

            ## if indel exist
            # F is 1
            # S is 0 --> there is indel
            # F + S = 1

            my $F_abs = abs $F[1] - $F_prepos;
            my $S_abs = abs $S[1] - $S_prepos;

            my $line = get_indel( \@F, \@S, $F_abs, $S_abs )
              if $F_abs + $S_abs == 1;
            print "$line\n" if $line;

            while (<$SEC>) {
                @S = split /\t/, $_;
                if ( $F[1] == $S[1] ) {
                    last;
                }
                elsif ( $F[1] < $S[1] ) {
                    last;
                }
                elsif ( $F[0] ne $S[0] ) {
                    last;
                }
                #print "1\t$F[1] > $S[1]\n";
            }

            #print 1;

        }
        ## fir.pos < sec.pos
        elsif ( $F[1] < $S[1] ) {

            ## if indel exist
            # F is 1
            # S is 0 --> there is indel
            # F + S = 1

            my $F_abs = abs $F[1] - $F_prepos;
            my $S_abs = abs $S[1] - $S_prepos;

            my $line = get_indel( \@F, \@S, $F_abs, $S_abs )
              if $F_abs + $S_abs == 1;

            print "$line\n" if $line;

            while (<$FIR>) {
                @F = split /\t/, $_;
                if ( $F[1] == $S[1] ) {
                    last;
                }
                elsif ( $F[1] > $S[1] ) {
                    last;
                }
                elsif ( $F[0] ne $S[0] ) {
                    last;
                }
                #print "2\t$F[1] < $S[1]\n";
            }

            #print 1;
        }

        ## not same chr
        next if $F[0] ne $S[0];

        #print 1;
    }
    elsif ( $F[0] ne $S[0] ) {

		my ($chr_low,$chr_high) = sort ( $F[0], $S[0] );

		if( $chr_low eq $F[0] )
		{
            while (<$FIR>) {
                @F = split /\t/, $_;
                if ( $F[0] eq $S[0] ) {
                    last;
                }
            }
			
		}
		elsif( $chr_low eq $S[0] )
		{
            while (<$SEC>) {
                @S = split /\t/, $_;
                if ( $F[0] eq $S[0] ) {
                    last;
                }
            }
			
		}
    }

    if ( $F[1] == $S[1] ) {
        my $line = compare( \@F, \@S, $F_prepos, $S_prepos );
        print "$line\n" if $line;
        ( $F_prepos, $S_prepos ) = ( $F[1], $S[1] );
        @F_pre = @F;
        @S_pre = @S;

    }

    #print "@F[0,1],@S[0,1]\n"
}

close $FIR
  or warn "$0 : failed to close input file '$FIR_file' : $!\n";
close $SEC
  or warn "$0 : failed to close input file '$SEC_file' : $!\n";
#################################################################################

sub get_indel {

    my ( $F, $S, $F_abs, $S_abs ) = @_;
    my @F = @$F;
    my @S = @$S;

    if ( $F_abs == 0 ) {

        my @F_sort = sort @F[ 8, 9 ];
        my $F_count =
          $F_sort[0] eq $F[8]
          ? "$F[8]/$F[9]=$F[10]/$F[11]"
          : "$F[9]/$F[8]=$F[11]/$F[10]";

        my $S_count = "*/$F[9]=$S_pre[7]/0";

        return (
            join "\t", @F[ 0, 1 ], $F_count, @F[ 3, 4, 7 ],
            @S_pre[ 0, 1 ], $S_count, "*/*", 0,
            $S_pre[7], "diff"
        ) if $F[7] >= 3 && $F[3] ne "*/*" && $S_pre[7] >= 3;

    }
    elsif ( $S_abs == 0 ) {
        my @S_sort = sort @S[ 8, 9 ];
        my $S_count =
          $S_sort[0] eq $S[8]
          ? "$S[8]/$S[9]=$S[10]/$S[11]"
          : "$S[9]/$S[8]=$S[11]/$S[10]";

        my $F_count = "*/$S[9]=$F_pre[7]/0";

        return (
            join "\t", @F_pre[ 0, 1 ],   $F_count, "*/*",
            0,         $F_pre[7], @S[ 0, 1 ],      $S_count,
            @S[ 3, 4, 7 ], "diff"
        ) if $S[7] >= 3 && $S[3] ne "*/*" && $F_pre[7] >= 3;
    }
}

sub compare {
    my ( $F, $S, $F_prepos, $S_prepos ) = @_;
    my @F = @$F;
    my @S = @$S;

    # indel
    if ( $F[2] eq '*' && $S[2] eq '*' ) {

        my @F_geno = sort @F[ 8, 9 ];
        my @S_geno = sort @S[ 8, 9 ];

        $F[3] = join "\/", sort split /\//, $F[3];
        $S[3] = join "\/", sort split /\//, $S[3];

        if ( $F[3] eq $S[3] ) {
        }
        elsif ( $F[3] ne $S[3] && $F_geno[1] eq $S_geno[1] ) {

            my @F_sort = sort @F[ 8, 9 ];
            my $F_count =
              $F_sort[0] eq $F[8]
              ? "$F[8]/$F[9]=$F[10]/$F[11]"
              : "$F[9]/$F[8]=$F[11]/$F[10]";

            my @S_sort = sort @S[ 8, 9 ];
            my $S_count =
              $S_sort[0] eq $S[8]
              ? "$S[8]/$S[9]=$S[10]/$S[11]"
              : "$S[9]/$S[8]=$S[11]/$S[10]";

            return (
                join "\t", @F[ 0, 1 ],
                $F_count,
                @F[ 3,           4, 7 ],
                @S[ 0,           1 ],
                $S_count, @S[ 3, 4, 7 ], "indel"
            ) if $F[7] >= 3 && $S[7] >= 3;
        }

    }

    # snp
    elsif ( $F[2] ne '*' && $S[2] ne '*' ) {
        if ( $F[3] eq $S[3] ) {

            #return 0;
        }
        elsif ( $F[3] ne 'N' && $S[3] ne 'N' ) {

            return ( join "\t", @F[ 0 .. 3, 5, 7 ], @S[ 0 .. 3, 5, 7 ], "snp" )
              if $F[7] >= 3 && $S[7] >= 3;
        }

    }
}

my $obj = __PACKAGE__->new;

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


 Usage : PileupCompare.pl  


 --a=s"         		1st pileup name
 --b=s"         		2nd pileup name
 --out-file=s"        output file name (default: variation.txt)



=head1 DESCRIPTION


./PileupCompare.pl -a s_1/s_1.bam.sorted.bam.qsub.pileup -b s_2/s_2.bam.sorted.bam.qsub.pileup 



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



