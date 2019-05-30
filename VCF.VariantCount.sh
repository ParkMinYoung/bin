perl -F'\t' -MMin -ane'
chomp@F;
next if /^##/;
@header=@F if /^#/;

$ref = length $F[3];
$alt = length $F[4];

if( $ref == 1 && $alt == 1 ){
	$type = "SNP";
}elsif( $ref == 1 && $alt > 1 ){
	$type = "INS";
}elsif( $ref > 1 && $alt == 1 ){
	$type = "DEL";
}

if(/PASS/){
	for ( 9 .. $#F ){
		if( $F[$_] ne "./." ){
			$h{$type}{$header[$_]}++;
			$h{Total}{$header[$_]}++;
		}
	}
}

}{ mmfss("VCF.VarCount", %h)' $1 


##CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  DNALink.PE.10p  DNALink.PE.15p  DNALink.PE.20p  DNALink.PE.30p  DNALink.PE.3p   DNALink.PE.5p   DNALink.PE.7p   DNALink.PE.9p
#chr11   2464219 .       CT      C       274.81  PASS    AB=0.930;AC=5;AF=0.417;AN=12;BaseQRankSum=2.681;DP=532;FS=4.788;HRun=4;HaplotypeScore=4234.0397;MQ=33.23;MQ0=0;MQRankSum=0.465;QD=0.52;ReadPosRankSum

