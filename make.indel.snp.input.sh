#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -anle'if(/^chr/){
if(length $F[3] == 1 && length $F[4] == 1){
    print STDOUT join "\t", $F[0],$F[1]-1,$F[1],"$F[3]/$F[4]"
}else{
    ($ref_len,$var_len)=(length $F[3],length $F[4]);
    if($ref_len > 1){
    print STDERR join "\t", $F[0],$F[1],$F[1]+$ref_len-1,substr($F[3],1,$ref_len-1)."/-"
    }else{
    print STDERR join "\t", $F[0],$F[1],$F[1],"-/".substr($F[4],1,$var_len-1)
    }
}
}' $1 2> $1.indel > $1.snp

else
	usage try.vcf.v4
fi

