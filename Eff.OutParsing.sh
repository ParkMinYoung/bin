#!/bin/sh


perl -F'\t' -MMin -MList::MoreUtils=uniq -asnle'
BEGIN{
		@order = 
		qw/
		SPLICE_SITE_ACCEPTOR
		SPLICE_SITE_DONOR
		FRAME_SHIFT
		EXON
		NON_SYNONYMOUS_CODING
		NON_SYNONYMOUS_START
		RARE_AMINO_ACID
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
		INTRAGENIC
		UPSTREAM
		DOWNSTREAM
		UTR_3_PRIME
		UTR_5_PRIME
		INTRON
		INTERGENIC
		NONE
		/;
}

next if /^##/;

if(/^#CHR/){
@sam = @F[9..$#F];
@sam = map { @{[split "\/", $_]}[0] } @sam;
next;
}
@data = @F[9..$#F];


$F[7]=~/EFF=(.+)/;
$EFF=$1;
$EFF =~ s/;EFF=.+//;
@anno = split ",", $EFF;
#!#$loc = join "-", @F[0,1];
$loc = join "\t", @F[0..6];

$F[7] =~ /AC=(\d+);/;
$AC{$loc}=$1;

$F[7] =~ /AF=(0.\d+);/;
$AF{$loc}=$1;

$h{"./."}=0;
$h{"0/0"}=0;
$h{"1/0"}=0;
$h{"0/1"}=0;
$h{"1/1"}=0;

map { $h{$1}++ if /^(\d\/\d|\.\/\.)/ } @data;

map { push @{ $sample{$loc}{$1} }, $sam[$_] if $data[$_] =~ /^(\d\/\d|\.\/\.)/ } 0 .. $#data;

for $i ( 0 .. $#data ){
	if( $data[$i] =~ /^(\d\/\d|\.\/\.)/ ){
		$sm = "$i|$sam[$i]";
		$sam_var_cnt{$sm}{$1}++;
	}
}

#map { print join ",", $_,  @{$sample{$loc}{$_}} } ("./.","0/0","1/0","1/1");
#map { print join ",", $_, @{$sample{$loc}{$_}} } sort keys %{$sample{$loc}};
#exit;

for $a ( @anno ){
		$a =~/(.+)\((.+)\)/;
		$region = $1;
		$anno=$2;
		$anno =~ s/\|/\t/g;

		print join "\t", @F[0..6], $region, $h{"./."},$h{"0/0"},$h{"0/1"},$h{"1/1"},$anno,
					  (join ",", uniq @{$sample{$loc}{"./."}}), 
					  (join ",", uniq @{$sample{$loc}{"0/0"}}), 
					  (join ",", uniq @{$sample{$loc}{"0/1"}}), 
					  (join ",", uniq @{$sample{$loc}{"1/1"}}), 
					  $AF{$loc}, $AC{$loc};
		$k=join "\t", @F[0..6];
#	push @{$m{$k}{$region}}, $anno;
		# bug fix
		push @{$m{$k}{$region}}, $anno if $anno !~ /WARNING_TRANSCRIPT/;
		
		$geno_cnt{$loc}{"./."}= $h{"./."};
		$geno_cnt{$loc}{"0/0"}= $h{"0/0"};
		$geno_cnt{$loc}{"0/1"}= $h{"0/1"};
		$geno_cnt{$loc}{"1/1"}= $h{"1/1"};
}


}{

mmfss_n("$f.SampleVariantCnt", %sam_var_cnt);

print STDERR join "\t", qw/CHROM POS ID REF ALT QUAL FILTER Impact Effect_Impact Functional_Class Codon_Change Amino_Acid_change Amino_Acid_length Gene_Name Gene_BioType Coding Transcript Exon GenotypeNum/, "./.", "0/0", "0/1", "1/1","./.", "0/0", "0/1", "1/1",AF,AC;
#print STDERR join "\t", qw/CHROM POS ID REF ALT QUAL FILTER Impact Effect_Impact Functional_Class Codon_Change Amino_Acid_change Gene_Name Gene_BioTypeCoding Coding Transcript Exon/, "./.", "0/0", "0/1", "1/1","./.", "0/0", "0/1", "1/1",AF,AC;

	for $i ( sort keys %m ){
		$i=~/^(\w+)\t(\d+)/;
		#!#$loc= "$1-$2";
		$loc= $i;
		
		for $j ( @order ){
			if( defined $m{$i}{$j} ){
				print STDERR join "\t", $i,$j,$m{$i}{$j}->[0], $geno_cnt{$loc}{"./."}, $geno_cnt{$loc}{"0/0"}, $geno_cnt{$loc}{"0/1"}, $geno_cnt{$loc}{"1/1"}, 
					  (join ",", uniq @{$sample{$loc}{"./."}}), 
					  (join ",", uniq @{$sample{$loc}{"0/0"}}), 
					  (join ",", uniq @{$sample{$loc}{"0/1"}}), 
					  (join ",", uniq @{$sample{$loc}{"1/1"}}), 
					  $AF{$loc}, $AC{$loc};
				last;
			}
		}
	}

' -- -f=$1 $1 > $1.SNPEFF.parsing 2> $1.SNPEFF.parsing.uniq


perl -F'\t' -anle'if(@ARGV){$k=join "\t",@F[0..4]; $h{$k}++ }else{$k=join "\t",@F[0..4]; print if !$h{$k}} ' $1.SNPEFF.parsing.uniq $1  | cut -f3 | grep rs > tmp
grep -f tmp $1.SNPEFF.parsing >> $1.SNPEFF.parsing.uniq

perl -F'\t' -anle'if(@ARGV){$k=join "\t",@F[0..4]; $h{$k}= (split ":", $F[9])[0]}else{$k=join "\t",@F[0..4]; print join "\t", @F[0..17], $h{$k} } ' $1 $1.SNPEFF.parsing.uniq > $1.SNPEFF.parsing.uniq.Report


perl -F'\t' -MMin -alne'
if($.>1){
	$type = $F[2] =~ /rs/ ? "dbSNP" : "Novel";
	$h{$F[7]}{"$type.Count"}++;
	$h{Total}{"$type.Count"}++;
	$h{$F[7]}{"$type.Percent"}=sprintf "%.2f", $h{$F[7]}{"$type.Count"}/$h{Total}{"$type.Count"}*100; 
	$h{Total}{"$type.Percent"}=sprintf "%.2f", $h{Total}{"$type.Count"}/$h{Total}{"$type.Count"}*100;
} 
}{
		@list = qw/
		SPLICE_SITE_ACCEPTOR
		SPLICE_SITE_DONOR
		FRAME_SHIFT
		EXON
		NON_SYNONYMOUS_CODING
		NON_SYNONYMOUS_START
		RARE_AMINO_ACID
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
		INTRAGENIC
		UPSTREAM
		DOWNSTREAM
		UTR_3_PRIME
		UTR_5_PRIME
		INTRON
		INTERGENIC
		NONE
		Total
		/;
		@header = qw/dbSNP.Count dbSNP.Percent Novel.Count Novel.Percent/;
		print join "\t", "Impact", @header;
		map { print join "\t", $_, $h{$_}{$header[0]},$h{$_}{$header[1]},$h{$_}{$header[2]},$h{$_}{$header[3]} } @list;


' $1.SNPEFF.parsing.uniq > $1.Impact.count



egrep "(SPLICE|FRAME|STOP|START|NON_SYNONYMOUS)_" $1.SNPEFF.parsing.uniq > $1.SNPEFF.parsing.uniq.HIGH
egrep "(SPLICE|FRAME|STOP|START|NON_SYNONYMOUS)_" $1.SNPEFF.parsing > $1.SNPEFF.parsing.HIGH

perl -F'\t' -anle'$l="$F[24],$F[25]"; @l=$l=~/(NIH\w+)/g;$h{join ",", sort @l}++ }{map { print join "\t", $_,$h{$_} } sort keys %h'  $1.SNPEFF.parsing.uniq.HIGH >  $1.SNPEFF.parsing.uniq.HIGH.intersect

GATK.vcf2GTsGPsGQsADs.sh $1 > $1.Gentoype
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
