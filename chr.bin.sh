#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

FILE=$(basename $1)
SIZE=$2
BINSIZE=${SIZE:=1000}

perl -F'\t' -asnle'
$c=0;
while(++$c*$bin < $F[1] ){
	print join "\t", $F[0], ($c-1)*$bin, $c*$bin-1;
}
print join "\t", $F[0], ($c-1)*$bin, $F[1];
' -- -bin=$BINSIZE $1 > $FILE.bin$BINSIZE.bed
#' -- -bin=1000 /home/adminrig/workspace.min/IonTorrent/IonTorrentDB/hg19.genome > bin.1k.bed

else
	usage "XXX.genome [ 1000 ]"
fi



