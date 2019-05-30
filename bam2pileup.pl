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

perl bam2pileup.pl --in-bam s_1.bam.sorted.bam --out-file s_1.bam.sorted.bam.anno --ref-fasta ~/Genome/maq_hq18/hg18.fasta --tile-file ~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed 

Options:

--in-bam=s"          input file name (bam format. and bai)
--out-file=s"        output file name
--ref-fasta=s"       reference fasta files
--tile-file=s"       tile file

EOF

    exit(1);

}

my ( $in_bam, $ref_fasta, $out_file, $tile_file );

GetOptions(
    "in-bam=s"    => \$in_bam,
    "out-file=s"  => \$out_file,
    "ref-fasta=s" => \$ref_fasta,
    "tile-file=s" => \$tile_file,
);

$out_file = $out_file || $in_bam . ".anno";

# high level API
my $sam = Bio::DB::Sam->new(
    -bam   => $in_bam,
    -fasta => $ref_fasta,
);

# get seq of ref
# $dna is sequence object
# $dna = $sam->seq("chr10",50000,5500);

my $W_file = $out_file;    # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

# callback code ref
my $snp_caller = sub {
    my ( $seqid, $pos, $p ) = @_;
    my ( @base, @qscore, );
    my %count =
      ( A => 0, C => 0, G => 0, T => 0, N => 0, Total => 0, Diff => 0 );
	my %mut;

    my $refbase = uc $sam->segment( $seqid, $pos, $pos )->dna;

    for my $pileup (@$p) {
        my $b = $pileup->alignment;

        next if $pileup->indel;    # don't deal with these ;-)
        my $qbase = uc substr( $b->qseq, $pileup->qpos, 1 );

        next if $qbase =~ /[nN]/;
        my $qscore = $b->qscore->[ $pileup->qpos ];

        #next if $qscore < 34;
        if ( $refbase ne $qbase && $qscore >= 34) {
            $count{Diff}++;
			$mut{$qbase}++;
        }
        $count{$qbase}++;
        $count{Total}++;
        push @base,   $qbase;
        push @qscore, $qscore;
    }
    my $count = join "\t", map { $count{$_} } qw/A C G T N Total Diff/;
	
	my $mut;
	if( $count{Diff} )
	{
		my @muts = sort keys %mut;
		my @muts_cnt = map { $mut{$_} } @muts;
		
		my $m = @muts ? join ",", @muts : "-";
		my $c = @muts_cnt ? join ",", @muts_cnt : "-";

		$mut = join "\t", $m, $c;
	}
	else
	{
		$mut = "-\t-";
	}

    print $W join( "\t",
        $seqid, $pos, $refbase, $mut,$count,
        ( join ",", @base ),
        ( join ",", @qscore ) ),
      "\n";
};

my @span = File2Array($tile_file);
for my $i (@span) {
    my ( $chr, $s, $e ) = split "\t", $i;
    $sam->pileup( "$chr:$s-$e", $snp_caller );

    #$sam->pileup( "chr10:85994827-85994900", $snp_caller );

}

close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";

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

