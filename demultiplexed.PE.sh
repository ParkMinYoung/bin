#!/bin/sh

# sed 's/,/\t/g' SamplesDirectories.csv  > SamplesDirectories.txt
source ~/.bash_function

if [ -f "$1" ];then

		#Demulti.Qseq2Sym.sh
		for i in `find 0?? -maxdepth 0 -type d`;do echo $i && cd $i && SolexaAnalysisStarter.Demulti.MakeSeq.nohup.sh && cd ..;done
		
		sleep 60
		perl -le'while($l=`qstat -u adminrig`){ $l=~/(parsing|merge|trim)/ ? sleep 60 : print localtime()." " & exit}'

		## mv s_/sample name

perl -F'\t' -anle'if($.>1){
	$l="s_".$F[1];
	$f1="$F[9]/Sequence/$l/$l.1.fastq";
	$f2="$F[9]/Sequence/$l/$l.2.fastq";
	mkdir $l if ! -d $l;
	print "mv $f1 $l/$F[2].1.fastq";
	print "mv $f2 $l/$F[2].2.fastq";
}' $1 | sh

 ### perl -F'\t' -anle'if($.>1){
 ### 	$l="s_".$F[1];
 ### 	$f1="$F[9]/Sequence/$l/$l.1.fastq";
 ### 	$t1="$F[9]/Sequence/$l/$l.1.fastq.trimed";
 ### 	$f2="$F[9]/Sequence/$l/$l.2.fastq";
 ### 	$t2="$F[9]/Sequence/$l/$l.2.fastq.trimed";
 ### 	$t_single="$F[9]/Sequence/$l/$l.1.fastq.single";
 ### 	mkdir $l if ! -d $l;
 ### 	print "mv $f1 $l/$F[2].1.fastq";
 ### 	print "mv $t1 $l/$F[2].1.fastq.trimed";
 ### 	print "mv $f2 $l/$F[2].2.fastq";
 ### 	print "mv $t2 $l/$F[2].2.fastq.trimed";
 ### 	print "mv $t_single $l/$F[2].1.fastq.single";
 ### }' $1 | sh

		## get summary
		find s_?/ -type f | grep 1.fastq$ | sort | xargs -i perl -nle'}{$r=$./4;print "$ARGV\t$r"' {} > read.summary 
		perl -MMin -ne'chomp && $h{length $_}{$ARGV}++ if $.%4==0 }{ mmfsn("trimed.readlength",%h)' `find s_? -type f| grep -e trimed$` 
		mkdir multiplex && mv s_? multiplex
		Target2gz.sh `find multiplex/ -type f | egrep "(fastq|trimed)"$`
		perl -le'while($l=`qstat -u adminrig`){ $l=~/Target2gz/ ? sleep 10 : print localtime()." " & exit}'
		mv trimed.readleng* read.summary s_? multiplex && mv multiplex/ ../Sequence/
else
		usage SampesDirectories.txt
fi



