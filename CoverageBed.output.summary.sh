
#!/bin/sh
source ~/.bash_function

REF2GENE=~/Genome/hg19Fasta/refGene.txt

if [ $# -eq 1 ] && [ -f "$1" ];then

perl -F'\t' -MMin -asne'if(@ARGV){ 
$ref2gene{$F[1]}=$F[12]
}elsif($F[3]=~/(.+)_exon/){
$h{$1}{ExonLen}+=$F[8];
$h{$1}{ExonCov}+=$F[7];
$h{$1}{ExonCnt}++;
$h{$1}{Symbol}=$ref2gene{$1} || "NonXXXX"
}else{
die "$.\t$_"}
}{ map { $h{$_}{Percent} = sprintf "%0.2f",$h{$_}{ExonCov}/$h{$_}{ExonLen}*100} keys %h;
mmfss("$out.gene",%h)
' -- -out=$1 $REF2GENE $1

else
	usage "coverageBed.output"
fi
