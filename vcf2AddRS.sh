perl -F'\t' -anle'

if(@ARGV){
	$k=join ":",@F[4..6];
	$h{$k}=$F[3];
}else{
	if(/^#/){
		print;
		next;
	}


	$ref_len = length $F[3];
	$var_len = length $F[4];

	if( $ref_len + $var_len == 2 ){
		$k= join ":", $F[0],$F[1]-1,$F[1];
	}elsif( $ref_len == 1 && $var_len >1){
		$k= join "\t", $F[0],$F[1],$F[1];
	}elsif( $ref_len > 1 && $var_len == 1 ){
		$k= join "\t", $F[0],$F[1]+1, $F[1]+$ref_len;
	}

	if( $F[2] eq "." ){
		$F[2]=$h{$k}
	}
	print join "\t",@F;
}

' $1 $2 > $2.AddRS.vcf

#' Call.snp.raw.vcf.CombineVariants.vcf.uniq.vcf.bed.AddRS Call.snp.raw.vcf.CombineVariants.vcf.uniq.vcf  

## intersetBed output  from vcf2bed.sh
## dbsnp : vcf 
## 10      12250049        12250050        rs116915631;+;C/T;single        10      12250049        12250050        .;C/.
## 10      12251031        12251032        rs117762280;+;C/T;single        10      12251031        12251032        .;C/.
## 10      12251077        12251078        rs78051508;+;G/T;single 10      12251077        12251078        .;G/.
## 10      12251238        12251239        rs2399795;+;A/C;single  10      12251238        12251239        rs2399795;A/C
## 10      12251894        12251895        rs12263442;+;A/G;single 10      12251894        12251895        .;G/.
## 10      12252058        12252059        rs17151406;+;C/G;single 10      12252058        12252059        rs17151406;G/C
## 10      12252216        12252217        rs2271804;-;C/T;single  10      12252216        12252217        rs2271804;G/A
## 10      12252462        12252463        rs11257597;+;A/T;single 10      12252462        12252463        .;A/.
## 10      12252549        12252550        rs115088873;+;C/T;single        10      12252549        12252550        .;C/.
## 10      12253182        12253183        rs17151411;+;C/G;single 10      12253182        12253183        .;G/.


## VCF



# 4       1129660 .       G       GTT     
# 4       1100037 rs35166968      TACAC   T

