#!/bin/sh

. ~/.bash_function

if [ $# -eq 2 ];then

echo `date` "$2"

FILE=$(basename $2)
DIR=impute2genotype.tmp
if [ ! -d $DIR ];then
    mkdir $DIR
fi

perl -MIO::Zlib -MMin -se'
BEGIN{
	%h=h($rslist,1,1);
}
#h1n(%h);
$fh=IO::Zlib->new($gen,"r");
while(<$fh>){
    print if /(rs\d+)/ && $h{$1};
}
' -- -rslist=$1 -gen=$2 > $DIR/$FILE.$$.tmp
#' -- -rslist="rslist" -gen=chr9_90000001_950000000.gen.gz
    
else 
	usage "rslist chr9_90000001_950000000.gen.gz"
fi
