#!/bin/sh

source ~/.bash_function

if [ -f "$1" ];then

samtools view $1 | 
perl -F'\t' -asnle'
BEGIN{
		open $P1, ">$file.read1.fastq";
		open $P2, ">$file.read2.fastq";
		open $S,  ">$file.single.fastq";
}

if(! defined $pre){
	$pre=$F[0];
	@pre=@F
}elsif( defined $pre ){
	$curr=$F[0];
	if( $pre eq $curr ){ 
		@curr=@F;
		if( $pre[1] > $curr[1] ){
			print $P2 join "\n", "\@$pre[0]/2", $pre[9], "+", $pre[10];
			print $P1 join "\n", "\@$curr[0]/1", $curr[9], "+", $curr[10];
		}else{
			print $P1 join "\n", "\@$pre[0]/1", $pre[9], "+", $pre[10];
			print $P2 join "\n", "\@$curr[0]/2", $curr[9], "+", $curr[10];
		}

		$pre=undef;
		$curr=undef;
		@pre=();
		@curr=();
	}else{
		print $S join "\n", "\@$pre[0]/1", $pre[9], "+", $pre[10];
		$pre=$F[0];
		@pre=@F;
	}
}
}{ print $S join "\n", "\@$pre[0]/1", $pre[9], "+", $pre[10] if $pre;
close $P1;
close $P2;
close $S;
' -- -file=$1

else
		usage "XXX.SortByName.bam"
fi



# ILLUMINA-CD89F7:31:FC:8:1:1085:16759    16      chr5    61264637        0       13M     *       0       0       AAAGATATATGAC   A6A:>::.4;?6;   XT:A:R  NM:i:0  X0:i:52 XM:i:0  XO:i:0  XG:i:0  MD:Z:13
# ILLUMINA-CD89F7:31:FC:8:1:1087:7029     99      chr5    37374009        28      16M     =       37374298        312     TGAATATAAAACTATC        C=1;@BBB8C@0=?B@        XT:A:U  NM:i:0  SM:i:5  AM:i:5  X0:i:1  X1:i:70 XM:i
# ILLUMINA-CD89F7:31:FC:8:1:1087:7029     147     chr5    37374298        28      23M     =       37374009        -312    GGAAGAAAATACCAGTCTACACC G9D9:38@=-BB=A4=B4B:BD- XT:A:U  NM:i:1  SM:i:23 AM:i:5  X0:i:1  X1:i:1  XM:i
# ILLUMINA-CD89F7:31:FC:8:1:1089:18342    0       chr5    37479612        37      26M     *       0       0       AAAATAACTCCTACTGACTAAAACCA      3CBB?@@4C1:11519=?=5BBBB;A      XT:A:U  NM:i:1  X0:i:1  X1:i:0  XM:i:1  XO:i
