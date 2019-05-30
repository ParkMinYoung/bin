#!/bin/sh


perl -F'\t' -anle'
BEGIN{
		@order = 
		qw/
		NON_SYNONYMOUS_CODING
		NON_SYNONYMOUS_START
		FRAME_SHIFT
		EXON
		UTR_5_PRIME
		SPLICE_SITE_ACCEPTOR
		SPLICE_SITE_DONOR
		START_LOST 
		START_GAINED
		STOP_GAINED
		STOP_LOST
		CODON_CHANGE_PLUS_CODON_DELETION
		CODON_CHANGE_PLUS_CODON_INSERTION
		CODON_DELETION
		CODON_INSERTION
		SYNONYMOUS_CODING
		SYNONYMOUS_STOP
		UPSTREAM
		DOWNSTREAM
		UTR_3_PRIME
		INTRON
		INTERGENIC
		INTRAGENIC
		RARE_AMINO_ACID
		NONE
		/;
}

next if /^#/;
@data = @F[9..$#F];

$F[7]=~/EFF=(.+)/;
$EFF=$1;
@anno = split ",", $EFF;

$h{"./."}=0;
$h{"0/0"}=0;
$h{"1/0"}=0;
$h{"0/1"}=0;
$h{"1/1"}=0;

map { $h{$1}++ if /^(\d\/\d)/ } @data;

for $a ( @anno ){
		$a =~/(.+)\((.+)\)/;
		$region = $1;
		$anno=$2;
		$anno =~ s/\|/\t/g;

		print join "\t", @F[0..6], $region, $h{"./."},$h{"0/0"},$h{"0/1"},$h{"1/1"},$anno;
		$k=join "\t", @F[0..6];
		push @{$m{$k}{$region}}, $anno;
		
		$loc = join "-", @F[0,1];
		$geno_cnt{$loc}{"./."}= $h{"./."};
		$geno_cnt{$loc}{"0/0"}= $h{"0/0"};
		$geno_cnt{$loc}{"0/1"}= $h{"0/1"};
		$geno_cnt{$loc}{"1/1"}= $h{"1/1"};
}


}{

print STDERR join "\t", qw/CHROM POS ID REF ALT QUAL FILTER Impact Effect_Impact Functional_Class Codon_Change Amino_Acid_change Gene_Name Gene_BioTypeCoding Coding Transcript Exon/, "./.", "0/0", "0/1", "1/1";

	for $i ( sort keys %m ){
		$i=~/^(\w+)\t(\d+)/;
		$loc= "$1-$2";
		
		for $j ( @order ){
			if( defined $m{$i}{$j} ){
				print STDERR join "\t", $i,$j,$m{$i}{$j}->[0], $geno_cnt{$loc}{"./."}, $geno_cnt{$loc}{"0/0"}, $geno_cnt{$loc}{"0/1"}, $geno_cnt{$loc}{"1/1"}, ;
				last;
			}
		}
	}

' $1 > $1.SNPEFF.parsing 2> $1.SNPEFF.parsing.uniq

#egrep "(SPLICE|FRAME|STOP|START|NON_SYNONYMOUS)_" $1.SNPEFF.parsing.uniq > $1.SNPEFF.parsing.uniq.HIGH
#egrep "(SPLICE|FRAME|STOP|START|NON_SYNONYMOUS)_" $1.SNPEFF.parsing > $1.SNPEFF.parsing.HIGH


# 1       2985412 UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000270722|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000378391|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000378398|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000441472|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000442529|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000511072|),UPSTREAM(LOW||||PRDM16|protein_coding|CODING|ENST00000514189|),UPSTREAM(LOW||||RP1-163G9.1|processed_transcript|NON_CODING|ENST00000321336|),UPSTREAM(LOW||||RP1-163G9.1|processed_transcript|NON_CODING|ENST00000445317|)
#				  EFF=STOP_GAINED(HIGH|NONSENSE|Cga/Tga|R/*|MPL|protein_coding|CODING|ENST00000372468|exon_1_43812116_43812300),STOP_GAINED(HIGH|NONSENSE|Cga/Tga|R/*|MPL|protein_coding|CODING|ENST00000372470|exon_1_43812116_43812300)



 #######     12 SPLICE_SITE_DONOR       HIGH
 #######    315 FRAME_SHIFT     HIGH
 #######      7 SPLICE_SITE_ACCEPTOR    HIGH
 #######      8 STOP_LOST       HIGH    MISSENSE
 #######     19 STOP_GAINED     HIGH    NONSENSE
 #######  12205 INTRON  LOW
 #######     48 START_GAINED    LOW
 #######   5544 UPSTREAM        LOW
 #######   1167 SYNONYMOUS_CODING       LOW     SILENT
 #######      3 SYNONYMOUS_STOP LOW     SILENT
 #######      1 CODON_INSERTION MODERATE
 #######      2 CODON_CHANGE_PLUS_CODON_DELETION        MODERATE
 #######      6 CODON_CHANGE_PLUS_CODON_INSERTION       MODERATE
 #######      9 CODON_DELETION  MODERATE
 #######   1315 NON_SYNONYMOUS_CODING   MODERATE        MISSENSE
 #######   1940 UTR_3_PRIME     MODIFIER
 #######    472 UTR_5_PRIME     MODIFIER
 #######   5412 DOWNSTREAM      MODIFIER
