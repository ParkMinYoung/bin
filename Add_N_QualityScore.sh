#!/bin/sh
# get quality score distribution from fastq file


source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ];then

	EXT=$(perl -sle'$f=~/\.(\w+)?$/;print $1' -- -f=$1)
	if [ $EXT == "gz" ];then
	
	# for illumina >= 1.3
	# zcat $1 | perl -MList::Util=sum -nle'map { $h{$_}++ } split "" if $.%4==0 }{ $total= sum @h{keys %h}; map { $cul+=$h{$_}; $p=sprintf "%0.2f\t%0.2f",$h{$_}/$total*100,$cul/$total*100; print join "\t", ord($_)-64, $_, $h{$_}, $p } sort {ord($a)<=>ord($b)} keys %h' > $1.Qscore
	# for hiseq CASAVA 1.8
		zcat $1 | \
		perl -MList::Util=sum -snle'
		if($.%4==0){
			print join "", map { chr( $_+$plus > 74 ? 73 : $_+$plus ) } unpack "C*", $_;

		}else{
				print 
		}' -- -plus=$2 | gzip -c > $1.Plus.$2.N.fastq.gz

	fi
else
	usage try.fastq{.gz} [plus score]
fi

