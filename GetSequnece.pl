#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  GetSequnece.pl
#
#        USAGE:  ./GetSequnece.pl
#
#  DESCRIPTION:  Get Sequence from stdin (chr1:1-1000) or file containing coordinates per line
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Min Young Park (mn), minmin@dnalink.com
#      COMPANY:  DNALink.inc
#      VERSION:  1.0
#      CREATED:  06/22/10 11:58:30
#     REVISION:  ---
#===============================================================================

use strict;

use Bio::DB::Fasta;
use Getopt::Long;

use base qw();
BEGIN { ; }

my ( $in_file, $out_file );
my ( $in_chr, $in_start, $in_end );
my ($coord);
#my ($ref) = ("/home/adminrig/Genome/maq_hq18/hg18.fasta");
my ($ref) = ("/home/adminrig/Genome/hg19Fasta/hg19.fasta");

GetOptions(
    "i|in-file:s"  => \$in_file,
    "o|out-file:s" => \$out_file,
    "c|coord:s"    => \$coord,
    "r|ref:s"      => \$ref,

);

## set : default out-file
$out_file = $in_file . ".seq" unless $out_file;

my $db = Bio::DB::Fasta->new($ref);    # one file or many files

#my $seqstring = $db->seq($id);        # get a sequence as string
#my $seqobj = $db->get_Seq_by_id($id);    # get a PrimarySeq obj
#my $desc = $db->header($id);          # get the header, or description, line

if ( ( !$in_file && !$coord ) || ( $in_file && $coord ) ) {
    get_usage();
}

$in_file ? batch_get_seq($in_file) : print get_seq($coord);

sub batch_get_seq {

    #=== READ File Handle ===#
    my $F_file = shift;    # input file name

    open my $F, '<', $F_file
      or die "$0 : failed to open input file '$F_file' : $!\n";
    while (<$F>) {
        chomp;
        print get_seq($_);
    }
    close $F
      or warn "$0 : failed to close input file '$F_file' : $!\n";
}

sub get_seq {
    my $coord = shift;
    if ( $coord =~ /(chr\w+):(\d+)-(\d+)/ ) {
        my ( $chr, $s, $e ) = ( $1, $2, $3 );
        my $seqobj = $db->get_Seq_by_id($chr);
        my $seq = $seqobj->subseq( $s, $e );
        return ">$coord\n$seq\n";
    }
    else {
        die "Cannot reconize $coord\n";
    }
}

=cut

The following methods return strings

$seqobj->display_id(); # the human read-able id of the sequence
$seqobj->seq();        # string of sequence
$seqobj->subseq(5,10); # part of the sequence as a string
$seqobj->accession_number(); # when there, the accession number
$seqobj->alphabet();   # one of 'dna','rna','protein'
$seqobj->primary_id(); # a unique id for this sequence irregardless
					   # of its display_id or accession number
$seqobj->desc()        # a description of the sequence



The following methods return an array of Bio::SeqFeature objects 

$seqobj->top_SeqFeatures # The 'top level' sequence features
$seqobj->all_SeqFeatures # All sequence features, including sub
						 # seq features
						 #


The following methods returns new sequence objects, but do not transfer features across:

$seqobj->trunc(5,10)  # truncation from 5 to 10 as new object
$seqobj->revcom       # reverse complements sequence
$seqobj->translate    # translation of the sequence


=cut

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
    Get Sequences from Reference file


=head1 SYNOPSIS


Usage : GetSequnece.pl (-i where/is/file|-c chr1:1-1000) [-o can/write/file.seq -r where/is/reference]

    "i|in-file:s"     input file name containing chrX:1-100 format per line 
    "o|out-file:s"    output file name (default: inupt.seq)
    "c|coord:s"       chrX:1-100 format
    "r|ref:s"     	  reference file path


=head1 DESCRIPTION


./GetSequnece.pl  



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



