#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  DivideSampleFromIndex.pl
#
#        USAGE:  ./DivideSampleFromIndex.pl  
#
#  DESCRIPTION:  divide sequences from sample index
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  03/22/10 16:26:58
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use XML::Simple;
use Getopt::Long;
use IO::File;
# $0 --in-xml ../GERALD_18-03-2010_adminrig/samplesheet.xml --in-read1 s_1.1.fastq --in-read2 s_1.2.fastq --mismatch 1

my ($in_xml, $in_read1, $in_read2)=();
my ($mismatch,)=(0,);
my $lane;
my %index2fh;
my @index;
my $unmatched = "unmatched";
mkdir $unmatched unless -d $unmatched;

GetOptions(
			'in-xml=s'       => \$in_xml,
			'in-read1=s'     => \$in_read1,
			'in-read2=s'     => \$in_read2,
			'mismatch=i'        => \$mismatch,
);

$lane = $1 if $in_read1 =~ /^s_(\d+)/;


my $ref = XMLin($in_xml);

my @xml = 
 ref $ref->{Lane}->[$lane-1]->{Sample} eq "HASH" ?
 $ref->{Lane}->[$lane-1]->{Sample} :
 @{ $ref->{Lane}->[$lane-1]->{Sample} };

for my $sam ( @xml )
{
	my $folder = $sam->{ID};
	my $index = $sam->{Index};
	$folder = "$lane.$folder";
	mkdir $folder unless -d $folder;
	
	my $fh1 = new IO::File "> $folder/$folder.1.fastq";
	my $fh2 = new IO::File "> $folder/$folder.2.fastq";
	$index2fh{$index} = [\$fh1, \$fh2] ;
}

@index = keys %index2fh;

open my $F1, "<", $in_read1 
    or die "Cannot read $in_read1\n";

open my $F2, "<", $in_read2
    or die "Cannot read $in_read2\n";

open my $W1, ">", "$unmatched/s_$lane.1.fastq"
    or die "Cannot write $unmatched/$lane.1.fastq\n";

open my $W2, ">", "$unmatched/s_$lane.2.fastq"
    or die "Cannot write $unmatched/$lane.2.fastq\n";

while(<$F1>)
{
	my $p11 = $_;
	my $p12 =<$F1>;
	my $p13 =<$F1>;
	my $p14 =<$F1>;

	my $p21 =<$F2>; 
	my $p22 =<$F2>;
	my $p23 =<$F2>;
	my $p24 =<$F2>;

	my ($mid,$fh1,$fh2);
	$mid = $1 if $p11 =~ /\#(.{6})\//;
	
	#print $p11 if not $mid;

	if( defined $index2fh{$mid} )
	{
		if( $index2fh{$mid} )
		{
			$fh1 = ${ $index2fh{$mid}->[0] } ;
			$fh2 = ${ $index2fh{$mid}->[1] } ;
		}
		else
		{
			($fh1,$fh2) = ($W1,$W2);
		}
	}
	else
	{
		my $MatchIndex = Mismatch( $mismatch, $mid, @index );
		#print "sub out : Mismatch : $MatchIndex\n";
		if ( $MatchIndex )
		{
			$index2fh{$mid} = $index2fh{$MatchIndex};
			
			$fh1 = ${ $index2fh{$mid}->[0] } ;
			$fh2 = ${ $index2fh{$mid}->[1] } ;
		}
		else
		{
			$index2fh{$mid} = [\$W1, \$W2]; 
			($fh1,$fh2) = ($W1,$W2);
		}
	}
	print $fh1 join("", $p11,$p12,$p13,$p14);
	print $fh2 join("", $p21,$p22,$p23,$p24);
	#print join("", $p11,$p12,$p13,$p14);
}

close $F1;
close $F2;
close $W1;
close $W2;

sub Mismatch
{
	my ($mismatch, $seq,@index) = @_;
	
	my @seq = split "", $seq;
	for my $in ( @index )
	{
		my @in = split "", $in;
		
		my $c;
		for my $i ( 0 .. $#seq ) 
		{
			$c++ if $seq[$i] ne $in[$i];
		}
		#print "$in\t$seq\t$c\n";
		return $in if $mismatch >= $c 

	}
	return '';
}

