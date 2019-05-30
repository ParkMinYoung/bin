
#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then


perl -F'\t' -anle'if(!/^#/){
if(length $F[3] == 1 && length $F[4] == 1){
    print STDOUT join "\t", $F[0],$F[1]-1,$F[1],"$F[3]/$F[4]",$F[1]
}else{
    ($ref_len,$var_len)=(length $F[3],length $F[4]);
    ($ref_geno,$var_geno)=(uc $F[3], uc $F[4]);
    if( $ref_len > $var_len ){
        #print;
	## deletion
	$ref_geno=~s/$var_geno//;
	$len=$ref_len-$var_len;
	$s=$F[1]+$var_len-1;
	$e=$s+$len;
	$new_ref=substr $var_geno, -1, 1;
	print STDERR join "\t", $F[0],$s,$e, $new_ref."/.-$len$ref_geno",$F[1] if $F[4]!~/,/
    }elsif( $ref_len < $var_len ){
	#print;
	## insertion
	$var_geno=~s/$ref_geno//;
	$len=$var_len-$ref_len;
	$s=$F[1]+$ref_len-1;
	$e=$s;
	$new_ref=substr $ref_geno, -1, 1;
	print STDERR join "\t", $F[0],$s,$e, $new_ref."/.+$len$var_geno",$F[1] if $F[4]!~/,/
    }
}
}' $1 2> $1.indel.tmp > $1.snp.tmp

cat $1.snp.tmp $1.indel.tmp > $1.link
rm -rf $1.snp.tmp $1.indel.tmp

perl -F'\t' -anle'if(!/^#/){
if(length $F[3] == 1 && length $F[4] == 1){
    print STDOUT join "\t", $F[0],$F[1]-1,$F[1],"$F[3]/$F[4]"
}else{
    ($ref_len,$var_len)=(length $F[3],length $F[4]);
    ($ref_geno,$var_geno)=(uc $F[3], uc $F[4]);
    if( $ref_len > $var_len ){
        #print;
	## deletion
	$ref_geno=~s/$var_geno//;
	$len=$ref_len-$var_len;
	$s=$F[1]+$var_len-1;
	$e=$s+$len;
	$new_ref=substr $var_geno, -1, 1;
	print STDERR join "\t", $F[0],$s,$e, $new_ref."/.-$len$ref_geno" if $F[4]!~/,/
    }elsif( $ref_len < $var_len ){
	#print;
	## insertion
	$var_geno=~s/$ref_geno//;
	$len=$var_len-$ref_len;
	$s=$F[1]+$ref_len-1;
	$e=$s;
	$new_ref=substr $ref_geno, -1, 1;
	print STDERR join "\t", $F[0],$s,$e, $new_ref."/.+$len$var_geno" if $F[4]!~/,/
    }
}
}' $1 2> $1.indel > $1.snp



perl -F'\t' -anle'if(!/^#/){
if(length $F[3] == 1 && length $F[4] == 1){
    
}else{
    ($ref_len,$var_len)=(length $F[3],length $F[4]);
    ($ref_geno,$var_geno)=(uc $F[3], uc $F[4]);
    if( $ref_len > $var_len ){
        #print;
	## deletion
	$ref_geno=~s/$var_geno//;
	$len=$ref_len-$var_len;
	$s=$F[1]+$var_len-1;
	$e=$s+$len;
	$new_ref=substr $var_geno, -1, 1;
	print if $F[4]=~/,/
    }elsif( $ref_len < $var_len ){
	#print;
	## insertion
	$var_geno=~s/$ref_geno//;
	$len=$var_len-$ref_len;
	$s=$F[1]+$ref_len-1;
	$e=$s;
	$new_ref=substr $ref_geno, -1, 1;
	print if $F[4]=~/,/
    }
	else{print}

}
}' $1 > $1.except


else
        usage "try.vcf [bcftools output]"
fi

