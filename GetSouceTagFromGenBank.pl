#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  GetSouceTagFromGenBank.pl
#
#        USAGE:  ./GetSouceTagFromGenBank.pl
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
#      CREATED:  07/13/10 12:20:25
#     REVISION:  ---
#===============================================================================

use strict;
use Getopt::Long;
use Bio::SeqIO;

my $seqfile = "human.rna.gbff";
my $seqio   = new Bio::SeqIO(
    -format => 'genbank',
    -file   => $seqfile
);

my $W_file = "$seqfile.tab";    # output file name

open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";

while ( my $seq = $seqio->next_seq ) {
    my $desc          = $seq->desc;
    my $access_number = $seq->accession_number;
    my $gi            = $seq->primary_id;

    # same object
    # $seq->get_SeqFeatures == $seq->top_SeqFeatures

    my ( $fts, $xref, $gene, $alias, $note, $sc, $chr ) = ("-") x 7;
    ($fts) = grep { $_->primary_tag eq 'gene' } $seq->get_SeqFeatures;
    $xref = join ",", $fts->get_tag_values('db_xref')
      if $fts->has_tag('db_xref');
    ($gene) = $fts->get_tag_values('gene') if $fts->has_tag('gene');
    ($alias) = $fts->get_tag_values('gene_synonym')
      if $fts->has_tag('gene_synonym');
    ($note) = $fts->get_tag_values('note') if $fts->has_tag('note');
    ($sc) = grep { $_->primary_tag eq 'source' } $seq->get_SeqFeatures;
    ($chr) = $sc->get_tag_values("chromosome") if $sc->has_tag('chromosome');

    print $W join( "\t",
        $chr, $gene, $alias, $access_number, $gi, $note, $desc, $xref ),
      "\n";
}
    close $W
      or warn "$0 : failed to close output file '$W_file' : $!\n";

=cut
	my %h;
    foreach my $feature ( $seq->top_SeqFeatures() ) {
        my ( $chr, $gene, $alias );

        $chr = $feature->get_tag_values("chromosome")
          if $feature->has_tag('chromosome');
        $gene = $feature->get_tag_values('gene') if $_->has_tag('gene');
        $alias = $feature->get_tag_values('gene_synonym')
          if $_->has_tag('gene_synonym');

        print 1;
    }
=cut

use base qw();
BEGIN { ; }

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


Usage : GetSouceTagFromGenBank.pl  

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


./GetSouceTagFromGenBank.pl  



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



