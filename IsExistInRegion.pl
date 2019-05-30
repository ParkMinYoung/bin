#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  IsExistInRegion.pl
#
#        USAGE:  ./IsExistInRegion.pl
#
#  DESCRIPTION:  check and return in target region
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (),
#      COMPANY:
#      VERSION:  1.0
#      CREATED:  03/25/10 15:14:31
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Getopt::Long;
use NgsCoverV2;


if ($#ARGV < 0 ) {
        print STDERR <<EOF;

usage :
$0 --in-file 1.set1.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.read.map --target-file ~/Genome/RP/tile.span100

Options:

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
EOF
	exit(1);
}


my ( $in_file,    $out_file,     $target_file );
my ( $in_chr,     $in_start,     $in_end, $in_id ) = ( 1, 2, 3, 4 );
my ( $target_chr, $target_start, $target_end, $target_id ) = ( 1, 2, 3, 4 );


GetOptions(
    "in-file=s"      => \$in_file,
    "out-file=s"     => \$out_file,
    "target-file=s"  => \$target_file,
    "in-chr=i"       => \$in_chr,
    "in-start=i"     => \$in_start,
    "in-end=i"       => \$in_end,
    "in-id=i"        => \$in_id,
    "target-chr=i"   => \$target_chr,
    "target-start=i" => \$target_start,
    "target-end=i"   => \$target_end,
    "targeti-id=i"   => \$target_id,
);

## set : default out-file
$out_file = $in_file . ".out" unless $out_file;

my %col = (
    chr   => $target_chr,
    start => $target_start,
    end   => $target_end,
    id    => $target_id,
);

my $obj = NgsCoverV2->new();
my $t = "tile";
$obj->GetReadPosition( $target_file, $t, %col );
$obj->make_set__IntSpan_obj($t);
my $tag = $t."-Set__IntSpan";


my	$W_file_name = $out_file;		# output file name

open  my $W, '>', $W_file_name
or die  "$0 : failed to open  output file '$W_file_name' : $!\n";


my	$F_file_name = $in_file;		# input file name

open  my $F, '<', $F_file_name
or die  "$0 : failed to open  input file '$F_file_name' : $!\n";
while(<$F>)
{
	chomp;
	my @F=split "\t",$_,4;
	my ($chr,$s,$e) = @F[$in_chr-1,$in_start-1,$in_end-1,$in_id-1];
	
	if( defined $obj->{$tag}{$chr} )
	{
		my $o = $obj->{$tag}{$chr};
		my $set = Set::IntSpan->new( [ $s .. $e ] );
		my $intersect = intersect $o $set;
		if( $intersect )
		{
			print $W "$_\n";
		}
	}
}

close  $F
or warn "$0 : failed to close input file '$F_file_name' : $!\n";

close  $W
or warn "$0 : failed to close output file '$W_file_name' : $!\n";

