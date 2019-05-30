#!/bin/sh

. ~/.bash_function

if [ $# -eq 4 ];then

F1=$1
F1_K=$2

F2=$3
F2_K=$4

perl -F'\t' -asnle'
BEGIN{
map { push @k1, $_-1} split ",", $key1;
map { push @k2, $_-1} split ",", $key2;

print STDERR "File1 : $ARGV[0]";
print STDERR "File2 : $ARGV[1]";

print STDERR "k1 : @k1";
print STDERR "K2 : @k2";

}

if(@ARGV){
    $k = join "\t", @F[@k1];
    $h{$k}++;
	
	if( ++$a == 1 ){
		$a_header = join "\t", @F[@v1];
	}
}else{
    $k = join "\t", @F[@k2];

	if( ++$b == 1 ){
		print
	}elsif( $h{$k} ){
        print 
    }
}' -- -key1=$F1_K -key2=$F2_K $1 $3

else
	usage "File1 File1_Key File2 File2_Key"
fi

