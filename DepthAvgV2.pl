#!/usr/bin/perl -w

use strict;

use List::Util qw/sum/;
use Getopt::Std;
use Array::IntSpan;
use Set::IntSpan;

use base qw();
BEGIN { ; }

my %args;
getopt( "i:t:s:e:c:b:d", \%args );


die get_usage( "-i input error") if ! $args{i} ;
die get_usage( "-t tile  error") if ! $args{t} ;
die get_usage( "-c chr col num  error") if ! $args{c} ;
die get_usage( "-c bp  col num  error") if ! $args{b} ;
die get_usage( "-d depth  col num  error") if ! $args{d} ;

my $c=$args{c}-1;
my $b=$args{b}-1;
my $d=$args{d}-1;

my %h;
open my $F, $args{i}
    or die "Cannot open $args{i}\n";
while(<$F>)
{
	chomp;
	my @F=split "\t";
	my($chr,$pos,$dep)=@F[$c,$b,$d];

	$h{$chr}{$pos} = $dep;
}
close $F;

open $F, $args{t}
     or die "Cannot open $args{t}\n";
while(<$F>)
{
	chomp;
	my @F=split "\t";
	my( $chr, $s,$e) = ($F[0], $F[1]-$args{s}, $F[2]+$args{e});
	
	my @l;
	for my $i ( $s .. $e )
	{
		push @l, 
		defined $h{$chr}{$i} ?
		$h{$chr}{$i}         :
                0                    ;
	}
	my @seq = grep {$_>0} @l;
	print join ("\t", $chr,$s,$e,@l+0, @seq+0, (sum @seq)/@l),"\n";
}
close $F;

sub get_usage {
	print @_,"\n";
    exec( 'perldoc', $0 );
}


__END__

=head1 NAME

=head1 SYNOPSIS

Usage : DepthAVG.pl -i[input] file -t[tile] tile -s 1000 -e 1000 -c 1 -b 2 -d 3


=head1 DESCRIPTION


DepthAVG.pl -i[input] file -t[tile] tile -s 1000 -e 1000 -c 1 -b 2 -d 3
    	
	mapview is file which created from maq mapview
	tile is file which includ tile region
	
	- i input  : needed c, b, d options 
	- t tile   : tile file
	- s start  : start num
	- e end    : end num
	- c chr    : chr col in the input file
	- b pos(bp): pos col in the input file
	- d depth  : depth col in the input file

=head1 EXSAMPLE


=head1 HISTORY

=cut



