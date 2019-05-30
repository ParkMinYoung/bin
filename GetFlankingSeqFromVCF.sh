#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then


perl -F'\t' -MBio::DB::Fasta -asnle'
BEGIN{
	$LEN = $len;
	$ref = "/home/adminrig/Genome/hg19Fasta/hg19.fasta";
	$db = Bio::DB::Fasta->new($ref);

sub get_seq {
	($chr,$s,$e) = @_;
#print join "\t", $chr,$s,$e;
	$seqobj = $db->get_Seq_by_id($chr);
	$seq = $seqobj->subseq( $s, $e );
	return($seq)
	}

}

next if /^#/; 
$r=length($F[3]); 
$a=length($F[4]); 


if( $r > 1 ){
	$type="deletion";
	$F[3] =~ /\w(.+)/;
	$ref= $1;
	$alt = "-";
	$ref_l = length($ref) ;

	$geno="$ref/$alt";	
#print join "\t", $F[3], $geno;

	$s = $F[1] + 1;
	$e = $s + $ref_l;

	$flanking_s = $s-($len);
	$flanking_e = $e+($len);

	$chr = /^chr/ ? $F[0] : "chr$F[0]";

#print join "\t", $chr, $s, $e;
	$seq=get_seq($chr, $s, $e);
	
#print join "\t", $chr, $flanking_s, $flanking_e;
	$seq=get_seq($chr, $flanking_s, $flanking_e);
#print $seq;

#print "ref_l : $ref_l";
	$left=substr $seq, 0, $len;
	$ref_geno=substr $seq, $len, $ref_l;
	$right=substr $seq, ($len+$ref_l), $len;

#print $left;
#print $ref_geno;
#print $right;

#print join "\t", "chr$F[0]", $left_s, $left_e, (join ";", $type, @F[0..4], "$F[3]/$F[4]", $geno);
#print join "\t", "chr$F[0]", $right_s, $right_e, (join ";", $type, @F[0..4], "$F[3]/$F[4]", $geno);


	$f_l_len = length($left);
	$f_r_len = length($right);

	print join "\t", "", @F[0..4],$left."[$geno]".$right, $type, $f_l_len, $f_r_len;

}elsif( $a > 1 ){
	$type="insertion";
	$F[4] =~ /\w(.+)/;
	$ref= "-";
	$alt = $1;

	$geno = "$ref/$alt";

	$s = $F[1];
	$e = $F[1];

	$flanking_s = $s-($len)+1;
	$flanking_e = $e+($len);

	$chr = /^chr/ ? $F[0] : "chr$F[0]";



#$seq=get_seq($chr, $s, $e);
#print join "\t", $chr, $s, $e;
	
#print join "\t", $chr, $flanking_s, $flanking_e;
	$seq=get_seq($chr, $flanking_s, $flanking_e);
#print join "\t", length($seq), $seq;

	$left=substr $seq, 0, $len;
	$right=substr $seq, $len, $len;

#print $left;
#print $right;


	$f_l_len = length($left);
	$f_r_len = length($right);

	print join "\t", "", @F[0..4],$left."[$geno]".$right, $type, $f_l_len, $f_r_len;



}else{
	$type="snp";
	$ref=$F[3];
	$alt=$F[4];
	$ref_l = length($ref) ;

	$geno = "$ref/$alt";

	$s = $F[1];
	$e = $F[1];

	$flanking_s = $s-($len);
	$flanking_e = $e+($len);

	$chr = /^chr/ ? $F[0] : "chr$F[0]";

#print join "\t", $chr, $s, $e;
	$seq=get_seq($chr, $s, $e);
	
#print join "\t", $chr, $flanking_s, $flanking_e;
	$seq=get_seq($chr, $flanking_s, $flanking_e);
#print $seq;

#print "ref_l : $ref_l";
	$left=substr $seq, 0, $len;
	$ref_geno=substr $seq, $len, $ref_l;
	$right=substr $seq, ($len+$ref_l), $len;

#print $left;
#print $ref_geno;
#print $right;


	$f_l_len = length($left);
	$f_r_len = length($right);

	print join "\t", "", @F[0..4],$left."[$geno]".$right, $type, $f_l_len, $f_r_len;


}
' -- -len=35 $1 > $1.FlankingSeq

else

	usage "XXX.vcf"

fi

