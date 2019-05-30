#!/usr/bin/perl -w
use strict;

use Bio::DB::Sam;
use Bio::Coordinate::GeneMapper;
use Bio::PrimarySeq;
use Getopt::Long;

use List::Util qw/sum/;
use Min;

if ( $#ARGV < 0 ) {
    print STDERR <<EOF;

usage :

perl extractVarInCDS.pl --in-bam ./1.set1/1.set1.bam.sorted.bam --ref-fasta ~/Genome/maq_hq18/hg18.fasta --ref-flat ~/Genome/RP/LeeJYGeneList.refFlat --in-anno ./1.set1/1.set1.bam.sorted.bam.anno
Options:

--in-bam=s"          input file name (bam format. and bai)
--in-anno=s"         input file name anno 
--ref-flat=s"        refFlat
--ref-fasta=s"       reference fasta 
--target-file=s"     target file name (ex: tile)
--out-file=s"        output file name

EOF

    exit(1);

}

my ( $in_bam, $in_anno, $ref_flat,, $ref_fasta, $target_file, $out_file );

GetOptions(
    "in-bam=s"      => \$in_bam,
    "in-anno=s"     => \$in_anno,
    "out-file=s"    => \$out_file,
    "target-file=s" => \$target_file,
    "ref-flat=s"    => \$ref_flat,
    "ref-fasta=s"   => \$ref_fasta,
);

$out_file = $out_file || $in_bam . ".nonsyn";

# high level API
my $sam = Bio::DB::Sam->new(
    -bam   => $in_bam,
    -fasta => $ref_fasta,
);

# declare variable
my ( $file, ) = ($ref_flat);
my $db        = get_ref_coordi($file);
my %db        = %$db;
my %h;

# get seq of ref
# $dna is sequence object
# $dna = $sam->seq("chr10",50000,5500);

for my $chr ( sort keys %db ) {
    for my $i ( @{ $db{$chr} } ) {
        my $cds = $i->{_cds};
        my ( $start, $end );

        my $match1 = Bio::Location::Simple->new(
            -seq_id => "cds1",
            -start  => $cds->start,
            -end    => $cds->end
        );
        my $match2 = Bio::Location::Simple->new(
            -seq_id => "cds2",
            -start  => $cds->start,
            -end    => $cds->end
        );

        my $pair =
          Bio::Coordinate::Pair->new( -in => $match1, -out => $match2 );
        my $split = Bio::Location::Split->new();

        for ( @{ $i->{_chr_exons} } ) {
            $_->seq_id("");
            $split->add_sub_Location($_);
        }
        my $res        = $pair->map($split);
        my @cds_region = $res->each_match;

        if ( $i->cds->strand == 1 ) {
            my $nt_num = 0;
            my @nt2pos;
            for my $cds_e (@cds_region) {
                my ( $start, $end ) = ( $cds_e->start, $cds_e->end );
                my $cds_seq = $sam->seq( "$chr", $start, $end );
                my @f_seq = split "", $cds_seq;

                for my $nt_index ( 0 .. $#f_seq ) {
                    $nt_num++;
                    push @nt2pos,
                      [
                        $f_seq[$nt_index],  $nt_num,
                        $start + $nt_index, $i->{_cds}->seq_id
                      ];
                }
            }

            for my $num ( 0 .. $#nt2pos ) {
                my ( $dna, $dna_num, $genomic_pos, $gene ) = @{ $nt2pos[$num] };
                my $n    = $num + 1;
                my $base = $n % 3;
                $base = $base || 3;
                my $aa = int( $num / 3 ) + 1;

                my @codon =
                  map { $_->[0] } @nt2pos[ ( $aa - 1 ) * 3 .. ($aa) * 3 - 1 ];
                my $codon = join "", @codon;
                push @{ $h{$chr}{$genomic_pos} },
                  [ $dna, $dna_num, $aa, $base, $codon, $gene, $i->cds->strand ];
            }
        }
        elsif ( $i->cds->strand == -1 ) {

            my $nt_num = 0;
            my @nt2pos;
            for my $cds_e ( reverse @cds_region ) {
                my ( $start, $end ) = ( $cds_e->start, $cds_e->end );
                my $cds_seq = $sam->seq( "$chr", $start, $end );
                my @f_seq = split "", reverse $cds_seq;

                for my $nt_index ( 0 .. $#f_seq ) {
                    $nt_num++;
                    push @nt2pos,
                      [
                        $f_seq[$nt_index], $nt_num,
                        $end - $nt_index,  $i->{_cds}->seq_id
                      ];
                }
            }

            for my $num ( 0 .. $#nt2pos ) {
                my ( $dna, $dna_num, $genomic_pos, $gene ) = @{ $nt2pos[$num] };
                my $n    = $num + 1;
                my $base = $n % 3;
                $base = $base || 3;
                my $aa = int( $num / 3 ) + 1;

                my @codon =
                  map { $_->[0] } @nt2pos[ ( $aa - 1 ) * 3 .. ($aa) * 3 - 1 ];
                my $codon = join "", @codon;
                push @{ $h{$chr}{$genomic_pos} },
                  [ $dna, $dna_num, $aa, $base, $codon, $gene, $i->cds->strand ];
            }
        }

        #    $seq =~ tr/ACGTacgt/TGCAtgca/;
    }
}

#################################################################################
my	$W_file = $out_file;		# output file name

open  my $W, '>', $W_file
or die  "$0 : failed to open output file '$W_file' : $!\n";

#=== READ File Handle ===#
my	$F_file = $in_anno;		# input file name

open  my $F, '<', $F_file
or die  "$0 : failed to open input file '$F_file' : $!\n";
while ( <$F> ) 
{
	chomp;
	my @F = split /\t/;

	if( defined $h{$F[0]}{$F[1]} && $F[3] ne "-")
	{
		for my $mut ( split ",", $F[3] )
		{
			for my $i ( @{ $h{$F[0]}{$F[1]} } )
			{
				my ( $dna, $dna_num, $aa, $base, $codon, $gene, $strand ) = @{ $i };
				my $codon_mut;
				my @c = @F;

				if ( $strand == 1 )
				{
					$codon_mut = $codon;
					substr $codon_mut, $base -1, length $mut, $mut
				}
				else
				{
					$codon =~ tr/ACGTacgt/TGCAtgca/;
					$codon_mut = $codon;
					$mut =~ tr/ACGTacgt/TGCAtgca/;
					$c[2] =~ tr/ACGTacgt/TGCAtgca/;
					$c[3] =~ tr/ACGTacgt/TGCAtgca/;
					$c[12] =~ tr/ACGTacgt/TGCAtgca/;
					@c[5..8] = @c[8,7,6,5];
					substr $codon_mut, $base -1, length $mut, $mut
				}
				
                my $ori_seq = Bio::PrimarySeq->new( -seq => $codon );
                my $ori_aa = $ori_seq->translate->seq;

                my $mut_seq = Bio::PrimarySeq->new( -seq => $codon_mut );
                my $mut_aa = $mut_seq->translate->seq;

				print $W join("\t", $gene, $F[0], $F[1], $strand, $c[2], $mut, $dna_num, $aa, $base, $codon, $codon_mut, $ori_aa.$aa.$mut_aa, @c[3..$#F]),"\n";
			}
		}
	}
}
close  $F
or warn "$0 : failed to close input file '$F_file' : $!\n";

close  $W
or warn "$0 : failed to close output file '$W_file' : $!\n";
#################################################################################




sub get_ref_coordi {
    my ($F_file) = @_;
    my %db;

    #################################################################################
    #=== READ File Handle ===#

    open my $F, '<', $F_file
      or die "$0 : failed to open input file '$F_file' : $!\n";
    while (<$F>) {
        chomp;
        my (
            $sym, $ref, $chr,   $strand, $g_s, $g_e,
            $c_s, $c_e, $block, $e_s,    $e_e
        ) = split /\t/;

        my @c_s = split ",", $e_s;
        my @c_e = split ",", $e_e;

        ## start pos correction
        $g_s++;
        $c_s++;
        map { $_++ } @c_s;

        my ( @cexons, $s_boolen, );
        $s_boolen = $strand eq "+" ? 1 : -1;

        my $m = Bio::Coordinate::GeneMapper->new( -in => 'chr', -out => 'cds' );

       #my $m = Bio::Coordinate::GeneMapper->new( -in => 'cds', -out => 'cds' );

        my $cds = Bio::Location::Simple->new(
            -seq_id => $sym . "|$ref",
            -strand => $s_boolen,
            -start  => $c_s,
            -end    => $c_e,
        );
        $m->cds($cds);

        for my $i ( 0 .. $#c_e ) {
            my $e = Bio::Location::Simple->new(
                -seq_id => $sym . "_exon",
                -strand => $s_boolen,
                -start  => $c_s[$i],
                -end    => $c_e[$i],
            );
            push @cexons, $e;
        }
        $m->exons(@cexons);

        push @{ $db{$chr} }, $m;

    }
    close $F
      or warn "$0 : failed to close input file '$F_file' : $!\n";
    #################################################################################

    return \%db;
}

__END__
oordinateMapper.t


 my @pairs = $sam->get_features_by_location(-type   => 'read_pair',
                                            -seq_id => 'chr10',
                                            -start  => 85992640,
                                            -end    => 86008860);

 for my $pair (@pairs) {
    my $length                    = $pair->length;   # insert length
    my ($first_mate,$second_mate) = $pair->get_SeqFeatures;
    my $f_start = $first_mate->start;
    my $s_start = $second_mate->start;
 }

 my @targets    = $sam->seq_ids;
 my @alignments = $sam->get_features_by_location(-seq_id => 'chr10',
                                                 -start  => 85992640,
                                                 -end    => 86008860);
 for my $a (@alignments) {

    # where does the alignment start in the reference sequence
    my $seqid  = $a->seq_id;
    my $start  = $a->start;
    my $end    = $a->end;
    my $strand = $a->strand;
    my $cigar  = $a->cigar_str;
    my $paired = $a->get_tag_values('PAIRED');

    # where does the alignment start in the query sequence
    my $query_start = $a->query->start;     
    my $query_end   = $a->query->end;
	my $query_id    = $a->query->seq_id;

    my $ref_dna   = $a->dna;        # reference sequence bases
    my $query_dna = $a->query->dna; # query sequence bases

    my @scores    = $a->qscore;     # per-base quality scores
    my $match_qual= $a->qual;       # quality of the match
 }

