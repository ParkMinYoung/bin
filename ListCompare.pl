#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE:  ListCompare.pl
#
#        USAGE:  ./ListCompare.pl
#
#  DESCRIPTION:  List Compare : list have more than three
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Min Young Park (mn), minmin@dnalink.com
#      COMPANY:  DNALink.inc
#      VERSION:  1.0
#      CREATED:  07/14/10 10:41:52
#     REVISION:  ---
#===============================================================================

use strict;

use Getopt::Long;
use List::Compare;
use Min;

use base qw();
BEGIN { ; }

my $file = $ARGV[0];
#my $file = "All.inipu.out.RS.DepthCnt";

my ( %position, %sam );
#################################################################################
#=== READ File Handle ===#
my $F_file = $file;    # input file name

open my $F, '<', $F_file
  or die "$0 : failed to open input file '$F_file' : $!\n";
while (<$F>) {
    chomp;
    my @F = split /\t/;
    #my ( $id, $key ) = ( $F[0], "$F[1]:$F[3]" );
    my ( $id, $key ) = ( $F[0], "$F[2]:$F[4]:$F[1]" );
    $position{$key}++;
    push @{ $sam{$id} }, $key;
}
close $F
  or warn "$0 : failed to close input file '$F_file' : $!\n";
#################################################################################

my @ids           = sort keys %sam;
my @data          = map { \@{ $sam{$_} } } @ids;
my $lcm           = List::Compare->new( '-u', '-a', @data );
my $memb_hash_ref = $lcm->are_members_which( [ sort keys %position ] );
my %output        = %{$memb_hash_ref};


my $W_file = "$file.VennCount";    # output file name
my $W1_file = "$file.VennCount.raw";    # output file name

open my $W1, '>', $W1_file
  or die "$0 : failed to open output file '$W1_file' : $!\n";

my %count;
for my $pos ( sort keys %output ) {
    my @idx   = @{ $output{$pos} };
    my $count = @idx;
    my $id    = join ",",$count,sort @ids[@idx];

	print $W1 join ("\t", $pos,$count,$id),"\n";
    $count{$id}++;
}

close $W1
  or warn "$0 : failed to close output file '$W1_file' : $!\n";



open my $W, '>', $W_file
  or die "$0 : failed to open output file '$W_file' : $!\n";
map { print $W "$_\t$count{$_}\n"; } sort keys %count;
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


Usage : ListCompare.pl  

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


./ListCompare.pl  



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



