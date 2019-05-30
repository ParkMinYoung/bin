#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  refFlat2bed.pl
#
#        USAGE:  ./refFlat2bed.pl
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
#      CREATED:  05/20/10 16:36:12
#     REVISION:  ---
#===============================================================================

use strict;

use Getopt::Long;

use base qw();
BEGIN { ; }

my ( $in_file,    $out_file,     $target_file );
my ( $in_chr,     $in_start,     $in_end, $in_id ) = ( 1, 2, 3, 4 );
my ( $target_chr, $target_start, $target_end, $target_id ) = ( 1, 2, 3, 4 );
my ( $sp_start, $sp_end, $span ) = ( 6, 2, 2000 );

GetOptions(
    "in-file=s"          => \$in_file,
    "out-file=s"         => \$out_file,
    "target-file=s"      => \$target_file,
    "in-chr=i"           => \$in_chr,
    "in-start=i"         => \$in_start,
    "in-end=i"           => \$in_end,
    "in-id=i"            => \$in_id,
    "target-chr=i"       => \$target_chr,
    "target-start=i"     => \$target_start,
    "target-end=i"       => \$target_end,
    "targeti-id=i"       => \$target_id,
    "splic-site-start=i" => \$sp_start,
    "splic-site-end=i"   => \$sp_end,
    "span=i"             => \$span,
);

## set : default out-file
$out_file = $in_file . ".bed" unless $out_file;

#################################################################################
#=== READ File Handle ===#
my $F_file = $in_file;    # input file name

my $W_file = $out_file;   # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
    chomp;
    my ( $gene, $ref, $chr, $strand, $gs, $ge, $cs, $ce, $block, $e_s, $e_e ) =
      split /\t/;
	
	next if $chr =~ /_/;

    my $sym = "$gene|$ref";
    my @e_s = split ",", $e_s;
    my @e_e = split ",", $e_e;

    map { $_++ } $gs, $cs, @e_s;

    my %exon_block;
    my @order = ( 1 .. @e_s, 1 .. @e_s );
    @exon_block{ @e_s, @e_e } =
      $strand eq "-"
      ? reverse @order
      : @order;

    my @merge  = sort { $a <=> $b } @e_s, @e_e, $cs, $ce;
    my @up_utr = grep { $_ < $cs } @merge;
    my @dn_utr = grep { $_ > $ce } @merge;
    my @exon   = grep { $_ >= $cs && $_ <= $ce } @merge;

    push @up_utr, $cs - 1 if @up_utr;
    push @dn_utr, $ce + 1 if @dn_utr;

    my @up = ( $gs - 1, $gs - 1 - $span );
    my @dn = ( $ge + 1, $ge + 1 + $span );

    @exon = reverse @exon if $strand eq "-";
    my %summary;
    for my $i ( 1 .. @exon / 2 ) {
        my $s = ( $i - 1 ) * 2;

        my ( $start, $end ) = sort { $a <=> $b } $exon[$s], $exon[ $s + 1 ];
        my $e_block = $exon_block{$start} || $exon_block{$end};
        if ( !$e_block ) {
            my @b_index =
              grep { $e_s[$_] < $start && $e_e[$_] > $start } 0 .. $#e_s;
            $e_block = $exon_block{ $e_s[ $b_index[0] ] };
        }

        my $id = "$sym CDS $i, EXON $e_block";

        my $other_start = $exon[ $s + 2 ];

        $summary{$start} = join "\t", $chr, $start, $end, $id;

        if ( $strand eq "-" ) {
            my ( $sp_s, $sp_e ) =
              sort { $a <=> $b } ( $start - 1, $start - $sp_start );

            $summary{$sp_s} = join "\t", $chr, $sp_s, $sp_e,
              "$sym CDS INT $i, INT $e_block sp start"
              if $other_start;

            $summary{$other_start} = join "\t", $chr, $other_start + 1,
              $other_start + $sp_end, "$sym CDS INT $i, INT $e_block sp end"
              if $other_start;
        }
        else {
            my ( $sp_s, $sp_e ) =
              sort { $a <=> $b } ( $end + 1, $end + $sp_start );
            $summary{$sp_s} = join "\t", $chr, $sp_s, $sp_e,
              "$sym CDS INT $i, INT $e_block sp start"
            #print join "\t", $chr, $sp_s, $sp_e,
            #  "$sym CDS INT $i, INT $e_block sp start\n"
              if $other_start;
            $summary{$other_start-1} = join "\t", $chr, $other_start - $sp_end,
              $other_start - 1, "$sym CDS INT $i, INT $e_block sp end"
            #print  join "\t", $chr, $other_start - $sp_end,
            #  $other_start - 1, "$sym CDS INT $i, INT $e_block sp end\n"
              if $other_start;
        }
    }

    for my $i ( 1 .. @up_utr / 2 ) {
        my $s = ( $i - 1 ) * 2;
        my ( $start, $end ) = sort { $a <=> $b } $up_utr[$s], $up_utr[ $s + 1 ];
        my $id =
          $strand eq "-"
          ? "3' UTR"
          : "5' UTR";
        my $e_block = $exon_block{$start} || $exon_block{$end};
        $summary{$start} = join "\t", $chr, $start, $end,
          "$sym $id EXON $e_block";
    }

    for my $i ( 1 .. @dn_utr / 2 ) {
        my $s = ( $i - 1 ) * 2;
        my ( $start, $end ) = sort { $a <=> $b } $dn_utr[$s], $dn_utr[ $s + 1 ];
        my $id =
          $strand eq "-"
          ? "5' UTR"
          : "3' UTR";
        my $e_block = $exon_block{$start} || $exon_block{$end};
		next if $start == $end;
        $summary{$start} = join "\t", $chr, $start, $end,
          "$sym $id EXON $e_block";

    }

    my $up_id = $strand eq "-" ? "downstream" : "upstream";
    my ( $up_s, $up_e ) = sort { $a <=> $b } @up;
    $summary{$up_s} = join "\t", $chr, $up_s, $up_e, "$sym $up_id";

    my $dn_id = $strand eq "-" ? "upstream" : "downstream";
    my ( $dn_s, $dn_e ) = sort { $a <=> $b } @dn;

    $summary{$dn_s} = join "\t", $chr, $dn_s, $dn_e, "$sym $dn_id";
	
   	map { print "$summary{$_}\n"; } sort { $a <=> $b } keys %summary;
}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";
close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";

#################################################################################

my $obj = __PACKAGE__->new;

#print $obj;

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


Usage : refFlat2bed.pl  

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


./refFlat2bed.pl  



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



