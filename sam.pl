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

perl sam.pl --in-bam 1.set1.chr10.bam --target-file /home/adminrig/Genome/RP/tile.span100 --ref-flat LeeJYGeneList.refFlat --ref-fasta hg18.fasta

Options:

--in-bam=s"          input file name (bam format. and bai)
--ref-flat=s"        refFlat
--ref-fasta=s"       reference fasta 
--target-file=s"     target file name (ex: tile)
--out-file=s"        output file name

EOF

    exit(1);

}

my ( $in_bam, $ref_flat,, $ref_fasta, $target_file, $out_file );

GetOptions(
    "in-bam=s"      => \$in_bam,
    "out-file=s"    => \$out_file,
    "target-file=s" => \$target_file,
    "ref-flat=s"    => \$ref_flat,
    "ref-fasta=s"   => \$ref_fasta,
);

$out_file = $out_file || $in_bam . ".anno";

# high level API
my $sam = Bio::DB::Sam->new(
    -bam   => $in_bam,
    -fasta => $ref_fasta,
);

# declare variable
my ( $file, ) = ($ref_flat);
my $db        = get_ref_coordi($file);
my %db        = %$db;
my %r = (1=>3,3=>1,2=>2);


my @SNPs;
my %record;
my @span = File2Array($target_file);

# get seq of ref
# $dna is sequence object
# $dna = $sam->seq("chr10",50000,5500);

for my $chr ( sort keys %db ) {
    for my $i ( @{ $db{$chr} } ) {
        my $cds = $i->{_cds};
		my ($start,$end);

=cut
		if ( $i->cds->strand == -1 )
		{
			($start,$end) = ($cds->start, $cds->end);
		}
		else
		{
			($start,$end) = ($cds->start, $cds->end+1);
		}
=cut 

        my $match1 = Bio::Location::Simple->new(
            -seq_id => "cds1",
            -start  => $cds->start,
            -end    => $cds->end+1
        );
        my $match2 = Bio::Location::Simple->new(
            -seq_id => "cds2",
            -start  => $cds->start,
            -end    => $cds->end+1
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

        my $seq;
        for my $cds_e (@cds_region) {
            my $s = $sam->seq( "$chr", $cds_e->start, $cds_e->end );
            $seq .= $s;
        }
        $i->{_name} = $cds->seq_id;
		if ( $i->cds->strand == -1 )
		{
			chop $seq;
			$seq =~ tr/ACGTacgt/TGCAtgca/;
		}
        $cds->seq_id( uc $seq );
    }
}

# callback code ref
my $snp_caller = sub {
    my ( $seqid, $pos, $p ) = @_;
    my $refbase = uc $sam->segment( $seqid, $pos, $pos )->dna;
    my ( @flag, %detail );

	my $strand;
    my $v = Bio::Location::Simple->new(
        -start => $pos,
        -end   => $pos,
    );

    for my $i ( @{ $db{$seqid} } ) {
        my $res = $i->map($v);
        my $cds_pos = $res->start ? $res->start : 0;

        if ( $cds_pos > 0 && $pos >= $i->cds->start && $pos <= $i->cds->end ) {
            $i->in("cds");
            $i->out("exon");

            my $exon = Bio::Location::Simple->new(
                -start => $cds_pos,
                -end   => $cds_pos
            );
            my $exon_res  = $i->map($exon);
            my $exon_name = $exon_res->seq_id;

            $i->in("chr");
            $i->out("cds");

			my ($nt_pos, $aa_pos);
			$strand = $i->cds->strand;
			if( $strand == -1 )
			{
				my $base_pos = length($i->cds->seq_id) + 1 - $cds_pos;
				$nt_pos = $base_pos%3;
				$aa_pos = int($cds_pos/3) ;
			}
			else
			{
				my $nt_pos = $cds_pos % 3;
				my $aa_pos = int ($cds_pos/3);
			}

            ## if remain is, increase ++1	
			if ( $strand == 1 && $nt_pos )
			{
            	$aa_pos++;
			}
			elsif( $strand == -1 && $nt_pos != 1 )
			{
				$aa_pos++;
			}
			my $rev_aa_pos = (length $i->{_cds}->seq_id)/3 + 1 - $aa_pos;
			my $codon;
			if ( $strand == 1 )
			{
            	$codon = substr $i->{_cds}->seq_id, ( $aa_pos - 1 ) * 3, 3;
			}
			else
			{
            	$codon = substr $i->{_cds}->seq_id, ( $rev_aa_pos - 1 ) * 3, 3;
			}

            push @flag, [ $aa_pos, $nt_pos, $codon, $exon_name, $i->{_name} ];

        }
    }

    if (@flag) {
        for my $pileup (@$p) {
            my $b = $pileup->alignment;
            next if $pileup->indel;    # don't deal with these ;-)

            my $qbase = substr( $b->qseq, $pileup->qpos, 1 );
            next if $qbase =~ /[nN]/;

            my $qscore = $b->qscore->[ $pileup->qpos ];
            next if $qscore < 34;

            push @{ $detail{ori}{$refbase} }, $qscore;

            if ( $refbase ne uc $qbase ) {
                push @{ $detail{mut}{ uc $qbase } }, $qscore;
            }
        }

        for my $i (@flag) {
            my ( $aa, $nt, $codon, $exon, $gene ) = @$i;
            for my $j ( sort keys %{ $detail{mut} } ) {
                my $mut = $codon;
				
				$refbase =~ tr/ACGTacgt/TGCAtgca/;
				$j =~ tr/ACGTacgt/TGCAtgca/;
                
				substr $mut, $nt - 1, length $j, $j;

				my ($ori_seq,$ori_aa,$mut_seq,$mut_aa,$snp);
				if( $strand == -1 )
				{	
					$codon = reverse $codon;
					$mut = reverse $mut;

				}

                $ori_seq = Bio::PrimarySeq->new( -seq => $codon );
                $ori_aa = $ori_seq->translate->seq;

                $mut_seq = Bio::PrimarySeq->new( -seq => $mut );
                $mut_aa = $mut_seq->translate->seq;

                $snp = $ori_aa . $aa . $mut_aa;
                $nt = $nt || 3;

#push @{ $detail{aa}{$snp} }, join "\t", $seqid,$pos,$gene,$exon,$refbase,$j,$snp,$aa,$nt,$codon,$mut,$ori_aa,$mut_aa;
                $detail{aa}{$snp} = join "\t", $seqid, $pos, $gene, $strand, $exon,
                  $refbase, $j, $snp, $aa, $r{$nt}, $codon, $mut, $ori_aa, $mut_aa;
            }
        }

        $record{$seqid}{$pos} = \%detail;
    }
};

for my $i (@span) {
    my ( $chr, $s, $e ) = split "\t", $i;
    $sam->pileup( "$chr:$s-$e", $snp_caller );

    #$sam->pileup( "chr10:85994827-85994900", $snp_caller );

}

my $W_file = $out_file;    # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

my @acgt = qw/A C G T N/;
for my $chr ( sort keys %record ) {
    for my $pos ( sort { $a <=> $b } keys %{ $record{$chr} } ) {
        my %count = ( A => 0, C => 0, G => 0, T => 0, N => 0 );
        my %tmp = %{ $record{$chr}{$pos} };
        my $mut_cnt;
        map { $count{$_} = @{ $tmp{ori}{$_} } } keys %{ $tmp{ori} };
        map { my $c = @{ $tmp{mut}{$_} }; $count{$_} = $c; $mut_cnt += $c }
          keys %{ $tmp{mut} };

        my $dep = sum @count{@acgt};
        next unless $mut_cnt;
        my $cnt = join "\t", @count{@acgt}, $dep, $mut_cnt;

        for my $snp ( sort keys %{ $tmp{aa} } ) {
            print $W join( "\t", $tmp{aa}{$snp}, $cnt ), "\n";
        }
    }
}

close $W
  or warn "$0 : failed to close output file '$W_file' : $!\n";

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

