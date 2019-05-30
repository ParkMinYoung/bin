perl -F'\t' -anle'
BEGIN{
	print join "\t", qw/ 
						Location
						HGNC	
						Consequence	
						cDNA_position
						CDS_position
						Protein_position
						Amino_acids
						Codons
						PolyPhen
						SIFT
						Condel
						PolyPhen_score
						SIFT_score
						Condel_score
						/;
}


if( !$h{$F[10]}++ ){
#if( /NON_SYN/ && !$h{$F[10]}++ ){
	# $F[24] polyphen
	($polyphen,$p_s)=split /\(/,$F[24];
	($sift,    $s_s) = split /\(/,$F[25];
	($condel,  $c_s) = split /\(/,$F[4];

	map { s/\)//; } ($p_s,$s_s,$c_s);
	print join "\t", @F[10,6,15..20],$polyphen,$sift,$condel,$p_s,$s_s,$c_s;
}
' $1 > $1.Uniq.Anno

#samples.varscan.snp.somatic.snp.annot.frequencies.VEP.input.vep.txt
