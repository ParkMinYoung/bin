#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -MList::MoreUtils=natatime,pairwise,mesh -MSet::IntSpan -anle' 
($gene, $ref, $chr, $strand, $exon_c, $e_s, $e_e) = @F[0..3,8..10];

next if $chr =~ /_/;

@s = split ",", $e_s;
@e = split ",", $e_e;

# reverse strand
if( $strand eq "-"){
	@s = reverse @s;
	@e = reverse @e;
}

@merge = mesh @s, @e;
# same command 
# @merge =  pairwise { ($a, $b) } @a, @b;


$it = natatime 2, @merge;
#!# $cds = new Set::IntSpan [$F[6]..$F[3]];

$exon_number=0;

while( ($s,$e) = $it -> () ){
	$exon_number++;
	print join "\t", $chr, $s, $e, "EXON_".$exon_number, $ref, $strand,  $gene;

}
print STDERR join "\t", $chr, $F[6], $F[7], (join ";", $ref, $gene) if $F[6] != $F[7];
' $1 > $1.exon  2> $1.cds

intersectBed -a $1.exon -b $1.cds | \
sort -u | \
cut -f1-3,7  | \
sortBed -i stdin | \
mergeBed -i stdin -nms | \
perl -F'\t' -anle'%h=();map{$h{$_}++} split ";",$F[3]; print join "\t", @F[0..2], (join ";", sort keys %h)' > $1.cds.bed

bed2intervals $1.cds.bed

perl -F'\t' -anle'print join "\t", @F[0..2], (join ";",@F[3,4,6])' $1.exon > $1.exon.bed

else
	usage "ADME.refFlat.txt"
fi
