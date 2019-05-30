#!/bin/sh

. ~/.bash_function

if [ $# -eq 6 ];then

F1=$1
F1_K=$2
F1_V=$3

F2=$4
F2_K=$5
F2_V=$6

perl -F'\t' -asnle'
BEGIN{
map { push @k1, $_-1} split ",", $key1;
map { push @k2, $_-1} split ",", $key2;

map { push @v1, $_-1} split ",", $val1;
map { push @v2, $_-1} split ",", $val2;

print STDERR "File1 : $ARGV[0]";
print STDERR "File2 : $ARGV[1]";

print STDERR "k1 : @k1";
print STDERR "K2 : @k2";

print STDERR "v1 : @v1";
print STDERR "v2 : @v2";


}

if(@ARGV){
    $k = join "\t", @F[@k1];
    $h{$k}= join "\t", @F[@v1];
}else{
    $k = join "\t", @F[@k2];
    $val = join "\t", @F[@v2];

    if( $h{$k} ){
        print join "\t", $k, $h{$k}, $val
    }
}' -- -key1=$F1_K -key2=$F2_K -val1=$F1_V -val2=$F2_V $1 $4

else
	usage "File1 File1_Key File1_Value File2 File2_Key File2_Value"
fi

