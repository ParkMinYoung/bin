#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  GetVarAnnotation.pl
#
#        USAGE:  ./GetVarAnnotation.pl
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
#      CREATED:  06/22/10 16:49:07
#     REVISION:  ---
#===============================================================================

use strict;

use Getopt::Long;

use Bio::DB::Fasta;
use Bio::Location::Simple;
use Bio::Coordinate::Pair;
use Bio::Coordinate::Collection;
use Bio::PrimarySeq;

use List::MoreUtils qw/pairwise mesh each_array/;
use Array::IntSpan;
use Set::IntSpan;
use Set::IntSpan::Island;

use base qw();
BEGIN { ; }

# default set
my $ref = "/home/adminrig/Genome/hg19Fasta/PerlFastq";

my $coord_file = "/home/adminrig/Genome/RefFlat/v37/refFlat.txt";

#my $coord_file         = "/home/adminrig/Genome/RefFlat/v37/refFlat.txt.chr22";
#my $coord_file = "/home/adminrig/Genome/RefFlat/v37/refFlat.txt.chr20";
#my $coord_file = "/home/adminrig/Genome/RefFlat/v37/refFlat.txt.chr19.NM";

#my $coord_file         = "/home/adminrig/Genome/RefFlat/v37/ensGene.txt.chr22";
#my $coord_file         = "/home/adminrig/Genome/RefFlat/v37/ensGene.txt";
my $format             = "refFlat";
my $gene_span_size     = 2000;
my $splicing_site_size = 2;
my $bin_size           = 100000;

# declare var
my ( $in_file, $out_file ) = ();

#$format = "ens";
#$in_file ="/home/adminrig/SolexaData/Solexa.3rd_4th.YeonSeiUni/Sample/s_3/s_3.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.bed.hg19.SIFT.input";
#$in_file = "YS1.bam.sorted.bam.pileup.AlleleCnt.var.SIFT.new.INDEL.bed.hg19.SIFT.input";

GetOptions(
    "c|coord:s"          => \$coord_file,
    "f|format:s"         => \$format,
    "i|in-file:s"        => \$in_file,
    "o|out-file:s"       => \$out_file,
    "r|ref:s"            => \$ref,
    "gs|gene-span:i"     => \$gene_span_size,
    "sp|splicing-site:i" => \$splicing_site_size,
);

# err handler
get_usage() if !$coord_file;
get_usage() if !$in_file;

## default out file set
$out_file = $out_file || $in_file . ".out";

# get db obj
my $db = Bio::DB::Fasta->new($ref);    # one file or many files

#my $seqobj = $db->get_Seq_by_id($chr);
#my $seq = $seqobj->subseq( $s, $e );

# get main obj
my $obj = __PACKAGE__->new( -file => $coord_file, -format => $format );

$obj->GetGeneInfo;

## input file handle ##
#
my $F_file = $in_file;                 # input file name
my $W_file = $out_file;                # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";
open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
    chomp;
    my ( $chr, $s, $e, $geno ) = split /\t/;
    my ( $ref_nt, $var_nt ) = split "\/", $geno;

    #my $line = $_;
	my $line = join "\t", $chr, $s, $e, $geno;
    
	my ( $indel_type, $indel_geno_num, $indel_geno );
    if ( $var_nt =~ /\+(\d+)(\w+)/ ) {
        ( $indel_geno_num, $indel_geno, $indel_type ) = ( $1, $2, "insertion" );

        ## insertion
        ## 1 2 +2cc
        ## 123456
        ## actaaa
        ##  *
        ##  +2cc
        ##   cc  insertion
        ## (2,2) = (2,2)

        ( $s, $e ) = ( $e, $e );
    }
    elsif ( $var_nt =~ /-(\d+)(\w+)/ ) {
        ( $indel_geno_num, $indel_geno, $indel_type ) = ( $1, $2, "deletion" );

        ## deletion
        ## 1 2 -2ta
        ## 123456
        ## actaaa
        ##  *
        ##  -2ta
        ##   ta  deletion
        ## (2+1,2+2) = (3,4)

        ( $s, $e ) = ( $e + 1, $e + $indel_geno_num );
    }

    my $found;

    my $e_bin = int( $e / $bin_size ) + 1;
    if ( defined $obj->{bin}{$chr}{$e_bin} ) {
        my @refs = keys %{ $obj->{bin}{$chr}{$e_bin} };

        my $pos = Bio::Location::Simple->new( -start => $s, -end => $e );
        for (@refs) {
            my ( $gene, $ref, $chr, $gs, $ge ) = split ",", $_;
            my $res = $obj->{DB}{$_}{pair}->map($pos);
            if ( defined $res->{_match} ) {

                my $region = $res->match->seq_id;
                if ( $region =~ /CDS/ ) {
                    my $cds_pos_s = $res->match->start;
                    my $cds_pos   = $res->match->end;
                    my $aa_pos_s  = int( $cds_pos_s / 3 );
                    my $aa_pos    = int( $cds_pos / 3 );
                    my $codon_s   = $cds_pos_s % 3;
                    my $codon     = $cds_pos % 3;

                    if   ($codon_s) { $aa_pos_s++ }
                    else            { $codon_s = 3 }

                    if   ($codon) { $aa_pos++ }
                    else          { $codon = 3 }

                    ( $aa_pos_s, $aa_pos ) =
                      sort { $a <=> $b } ( $aa_pos_s, $aa_pos );
                    my $seqobj = $db->get_Seq_by_id($chr);

                    ## get cds sequneces
                    my $seq;
                    for ( @{ $obj->{DB}{$_}{cds} } ) {
                        $seq .= $seqobj->subseq(@$_);
                    }

                    my ( $ref_c, $var_c ) = ( $ref_nt, $var_nt );
                    ## if $strand eq "-" ?
                    if ( $res->match->strand == -1 ) {
                        $seq = reverse $seq;
                        $seq =~ tr/ACGTacgt/TGCATGCA/;

                        $var_c =~ tr/ACGTacgt/TGCATGCA/;
                        $ref_c =~ tr/ACGTacgt/TGCATGCA/;

                        $var_c =~ s/([ACGT]+)/reverse $1/e;
                    }

                    my $aa_pos_diff = $aa_pos - $aa_pos_s + 1;
                    my $codon_nt = substr $seq, 3 * ( $aa_pos_s - 1 ),
                      3 * $aa_pos_diff;

                    #my $codon_nt_mut = $codon_nt;
                    #substr $codon_nt_mut, $codon - 1, 1, $var_c;
                    my $codon_nt_mut = "-";

                    #substr $codon_nt_mut, $codon - 1, 1, $var_c;

                    my $ori_seq = Bio::PrimarySeq->new( -seq => $codon_nt );
                    my $ori_aa = $ori_seq->translate->seq;

                   #my $mut_seq = Bio::PrimarySeq->new( -seq => $codon_nt_mut );
                   #my $mut_aa  = $mut_seq->translate->seq;
                    my $mut_seq = "-";
                    my $mut_aa  = "-";
                    $codon = join "-", $codon_s, $codon;

                  #print "$codon_nt/$codon_nt_mut\t$ori_aa\t$mut_aa\t$aa_pos\n";
                    my @lines = (
                        $line,               $gene,
                        $ref,                $region,
                        $ref_c,              $var_c,
                        $codon_nt,           $codon_nt_mut,
                        $ori_aa,             $mut_aa,
                        "$aa_pos_s-$aa_pos", $codon,
                        "$indel_type|$s|$e"
                    );
                    print $W ( join "\t", @lines ), "\n";
                }
                else {
                    my @lines = ( $line, $gene, $ref, $region, ("") x 8 );
                    $lines[12] = "$indel_type|$s|$e";
                    print $W ( join "\t", @lines ), "\n";
                }
                $found++;
            }
        }
    }
    my @lines = ( $_, "Non Genic", ("") x 10 );
    $lines[12] = "$indel_type|$s|$e";
    print $W ( join "\t", @lines ), "\n" if !$found;
}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";
close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";
#################################################################################

#########################################################################################
#### subroutine
#########################################################################################

sub GetGeneInfo {
    my $self   = shift;
    my $format = $self->{-format};

    #my $sub    = "GetGeneInfo_" . $format;
    my $sub = "GetGeneInfo_";

    ## for other file format extension
    $self->$sub;
}

#sub GetGeneInfo_refFlat {
sub GetGeneInfo_ {
    my $self = shift;
    my %all_region;
    my $F_file = $self->{-file};     # input file name
    my $format = $self->{-format};

    open my $F, '<', $F_file
      or die "$0 : failed to open input file '$F_file' : $!\n";
    while (<$F>) {
        chomp;

        #print "$.\n";
        my (
            $gene, $ref, $chr,   $strand, $gs, $ge,
            $cs,   $ce,  $block, $es_l,   $ee_l
        ) = split /\t/;

        if ( $format eq "refFlat" ) {
            (
                $gene, $ref, $chr,   $strand, $gs, $ge,
                $cs,   $ce,  $block, $es_l,   $ee_l
            ) = split /\t/;
        }
        elsif ( $format eq "ens" || $format eq "refGene" ) {
            my ( $num1, $num2 );
            (
                $num1, $ref,   $chr,  $strand, $gs,   $ge, $cs,
                $ce,   $block, $es_l, $ee_l,   $num2, $gene
            ) = split /\t/;
        }

        ## make exon block array
        my @es = split ",", $es_l;
        my @ee = split ",", $ee_l;

        ## convert 0 orient to 1 orient
        map { $_++ } $gs, $cs, @es;

        # if dont have cds region
        # $cs == $ce+1
        ( $cs, $ce ) = ( '', '' ) if $cs == $ce + 1;

        ## exception no cds
        #{    }
        next if !$cs;

        #my @exons = pairwise { $a + $b } @es, @ee;
        my @exons;
        my $ea = each_array( @es, @ee );
        while ( my ( $a, $b ) = $ea->() ) {
            push @exons, [ $a, $b ];
        }

        my $gene_set = Set::IntSpan->new( [ [ $gs, $ge ] ] );
        my $cds_set  = Set::IntSpan->new( [ [ $cs, $ce ] ] );
        my $exon_set = Set::IntSpan->new( [@exons] );

        my @exon = $strand eq "+" ? @exons : reverse @exons;
        my @exon_list;
        my $exon_n;
        for (@exon) {
            $exon_n++;
            push @exon_list, [ @$_, "EXON $exon_n" ];
        }
        @exon_list = $strand eq "+" ? @exon_list : reverse @exon_list;
        my $WhatNumExon = Array::IntSpan->new(@exon_list);

        my %gene;
        ## get cds region
        my $cds_region = intersect $cds_set $exon_set;
        map { $gene{ $_->[0] } = join "\t", @$_, "CDS" } spans $cds_region;

        ## get utr region
        my $utr_region = diff $exon_set $cds_set;
        my ( @left, @right );

        for ( spans $utr_region ) {
            $cs > $_->[0] ? push @left, $_ : push @right, $_;
        }

        if ( $strand eq "+" ) {
            map { $gene{ $_->[0] } = join "\t", @$_, "5UTR" } @left;
            map { $gene{ $_->[0] } = join "\t", @$_, "3UTR" } @right;
        }
        else {
            map { $gene{ $_->[0] } = join "\t", @$_, "3UTR" } @left;
            map { $gene{ $_->[0] } = join "\t", @$_, "5UTR" } @right;
        }

        ## get intron region
        my $intron_region = diff $gene_set $exon_set;

        my @intron =
          $strand eq "+" ? spans $intron_region : reverse spans $intron_region;
        my @intron_list;
        my $intron_n;
        for (@intron) {
            $intron_n++;
            push @intron_list, [ @$_, "INTRON $intron_n" ];
        }
        @intron_list = $strand eq "+" ? @intron_list : reverse @intron_list;
        my $WhatNumIntron = Array::IntSpan->new(@intron_list);

        ## get splicing site
        my $cds_intron_region    = intersect $cds_set $intron_region;
        my $cds_region_span_sp_n = pad $cds_region $splicing_site_size;
        my $sp_region = intersect $cds_intron_region $cds_region_span_sp_n;
        map { $gene{ $_->[0] } = join "\t", @$_, "SP" } spans $sp_region;

        ## get intron region without splicsing site
        my $only_intron_region = diff $intron_region $sp_region;
        map { $gene{ $_->[0] } = join "\t", @$_, "ONLY_INTRON" }
          spans $only_intron_region;

        ## get pad +-2K from gene region
        my $gene_span_region    = pad $gene_set $gene_span_size;
        my $gene_up_down_region = diff $gene_span_region $gene_set;
        my ( $left, $right ) = spans $gene_up_down_region;

        if ( $strand eq "+" ) {
            $gene{ $left->[0] }  = join "\t", @$left,  "UPstream";
            $gene{ $right->[0] } = join "\t", @$right, "DWstream";
        }
        else {
            $gene{ $left->[0] }  = join "\t", @$left,  "DWstream";
            $gene{ $right->[0] } = join "\t", @$right, "UPstream";
        }

        my @pos =
          $strand eq "+"
          ? sort { $a <=> $b } keys %gene
          : sort { $b <=> $a } keys %gene;

        my $strand2num = $strand eq "+" ? 1 : -1;
        my $cds_count  = 0;
        my $transcribe = Bio::Coordinate::Collection->new;

        for my $i (@pos) {
            my ( $s, $e, $info ) = split "\t", $gene{$i};
            my $region;
            if ( $info !~ /stream/ ) {
                if ( $info =~ /CDS|UTR/ ) {
                    $region = $WhatNumExon->lookup($s);
                }
                else {
                    $region = $WhatNumIntron->lookup($s);
                }
            }
            else {
                $region = $info;
            }

            #print "$s\t$e\t$info\t$region\n";
            my $gene = Bio::Location::Simple->new(
                -seq_id => 'gene',
                -start  => $s,
                -end    => $e,
                -strand => 1,
            );

            my $match;
            if ( $info =~ /CDS/ ) {
                my ( $cds_start, $cds_end ) =
                  ( $cds_count + 1, $cds_count + $e - $s + 1 );
                $match = Bio::Location::Simple->new(
                    -seq_id => "$info $region",
                    -start  => $cds_start,
                    -end    => $cds_end,
                    -strand => $strand2num,
                );
                $cds_count = $cds_end;
            }
            else {
                $match = Bio::Location::Simple->new(
                    -seq_id => "$info $region",
                    -start  => 1,
                    -end    => $e - $s + 1,
                    -strand => $strand2num,
                );
            }
            my $pair = Bio::Coordinate::Pair->new(
                -in  => $gene,
                -out => $match,
            );
            $transcribe->add_mapper($pair);

        }

        #my $cds_r         = $cds_region->size;
        #my $utr_r         = $utr_region->size;
        #my $intron_r      = $intron_region->size;
        #my $only_intron_r = $only_intron_region->size;
        #my $sp_r          = $sp_region->size;
        #my $up_down_r     = $gene_up_down_region->size;

        #print "up,dw\t\t$up_down_r\n";
        #print $gene_up_down_region->run_list, "\n";
        #print "cds\t\t$cds_r\n";
        #print $cds_region->run_list, "\n";
        #print "utr\t\t$utr_r\n";
        #print $utr_region->run_list, "\n";
        #print "intron\t\t$intron_r\n";
        #print $intron_region->run_list, "\n";
        #print "only_intron\t\t$only_intron_r\n";
        #print $only_intron_region->run_list, "\n";
        #print "sp\t\t$sp_r\n";
        #print $sp_region->run_list, "\n";
        #print "total\t\t", $cds_r + $utr_r + $intron_r, "\n";
        #print "total\t\t", $cds_r + $utr_r + $only_intron_r + $sp_r, "\n";
        #print "obj\t\t", $gene_set->size, "\n";
        #print $gene_set->run_list, "\n";

        #print 1;

        my $id = join ",", $gene, $ref, $chr, $gs, $ge;

        $self->{DB}{$id}{pair} = $transcribe;
        @{ $self->{DB}{$id}{cds} } = spans $cds_region;

        ## get binning region
        my ( $gene_span_s, $gene_span_e ) =
          ( $gene_span_region->min, $gene_span_region->max );

#my $ref_region = Set::IntSpan::Island->new( $gene_span_region->min, $gene_span_region->max );;
#$all_region{$chr}{$ref} = $ref_region;

        my ( $gene_span_s_bin, $gene_span_e_bin ) = (
            int( $gene_span_s / $bin_size ) + 1,
            int( $gene_span_e / $bin_size ) + 1
        );
        map { $self->{bin}{$chr}{$_}{$id}++ } $gene_span_s_bin .. $gene_span_e_bin;
        print "read gene : $.\r";
    }
    close $F
      or warn "$0 : failed to close input file '$F_file' : $!\n";

=cut

	for my $chr ( sort keys %all_region )
	{
		my $covers = Set::IntSpan::Island->extract_covers( $all_region{$chr} );
		my @region;
		for my $cover ( @$covers )
		{
			my ($s,$e) = split "-", $cover->[0];
			my @list = @{$cover->[1]};
			if( @list )
			{
				push @region, [$s,$e,join ",",@list];
			}
		}
		$self->{Region}{$chr}=Array::IntSpan->new(@region);
		#print 1;

	}
=cut

}

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


Usage : GetVarAnnotation.pl --in-file input.txt [--coord refflat.txt --format refFlat --out-file input.txt.out --ref hg19.fasta --gene-span 2000 --splicing-site 2]


    c|coord:s          => coordinate file : refFlat.txt [default v37. refflat]
    f|format:s         => format refFlat|ens|refGene    [default refFlat]
    i|in-file:s        => in file : *.hgXX.SIFT.input
    o|out-file:s       => out file                      [default in_file.out] 
    r|ref:s            => reference fasta file          [default hg19.fasta]
    gs|gene-span:i     => gene span size(up,down stream][default 2000bp]
    sp|splicing-site:i => splicing site size            [defualt 2bp]



=head1 DESCRIPTION


./GetVarAnnotation.pl  



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



