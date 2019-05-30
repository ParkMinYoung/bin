#!/usr/bin/perl -w 
#===============================================================================
#
#         FILE: ViwerRegionInTile.pl 
#
#        USAGE:  ./ViwerRegionInTile.pl
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
#      CREATED:  01/08/10 15:34:02
#     REVISION:  ---
#===============================================================================

use strict;

use Data::Dumper;
use Getopt::Std;
use Array::IntSpan;
use Set::IntSpan;

use base qw();
BEGIN { ; }

my %args;
getopt( "i:t:s:e:c:b:", \%args );

die get_usage( "-i input error") if ! $args{i} ;
die get_usage( "-t tile  error") if ! $args{t} ;
die get_usage( "-c chr col num  error") if ! $args{c} ;
die get_usage( "-c bp  col num  error") if ! $args{b} ;

my $c=$args{c}-1;
my $b=$args{b}-1;

#print Dumper \%args;

my $obj = __PACKAGE__->new;

#################################################################################
#=== READ File Handle ===#
my $W_file = $args{t};    # input file name

open my $W, '<', $W_file
  or die "$0 : failed to open input file '$W_file' : $!\n";
while (<$W>) {
    chomp;
    my @F = split /\t/;
    push @{ $obj->{tile}{ $F[0] } }, [ $F[1]-$args{s}, $F[2]+$args{e}, "$F[1]-$F[2]" ];
}
close $W
  or warn "$0 : failed to close input file '$W_file' : $!\n";

#
###############################################################################

for my $chr ( keys %{ $obj->{tile} } ) {
	
	my $fir = shift @{ $obj->{tile}{$chr} };
    my $tmp  = Array::IntSpan->new( $fir );
	for my $i ( @{ $obj->{tile}{$chr} } ) 
	{
		$tmp -> set_range( @{$i} )
	}
	$obj->{obj}{$chr} = $tmp
}



#################################################################################
#=== READ File Handle ===#
my	$I_file = $args{i};		# input file name

open  my $I, '<', $I_file
or die  "$0 : failed to open input file '$I_file' : $!\n";
while ( <$I> ) 
{
	chomp;
	my @F= split "\t";
	if ( defined $obj->{obj}{$F[$c]} && $obj->{obj}{$F[$c]}-> lookup($F[$b]) )
	{
		print $_,"\n";
	}
}
close  $I
or warn "$0 : failed to close input file '$I_file' : $!\n";
#################################################################################



sub new {
    my $class = shift;
    my $self  = {@_};
    bless $self, $class;
}

sub get_usage {
	print @_,"\n";
    exec( 'perldoc', $0 );
}

__END__

=head1 NAME

=head1 SYNOPSIS

Usage : ViewerRegionInTile.pl -i mapview -t tile -s 1000 -e 1000 -c 1 -b 2



=head1 DESCRIPTION


./ViewerRegionInTile.pl -i[input] mapview -t[tile] tile -s 1000 -e 1000
    	
	mapview is file which created from maq mapview
	tile is file which includ tile region
	-s numeric
	-e numeric
	-c chromosome col [numeric]
	-b bp col [numeric]


=head1 OPTIONS

-
-
-
-
-


=head2 1.



=head1 EXSAMPLE

=head1 HISTORY

=cut



