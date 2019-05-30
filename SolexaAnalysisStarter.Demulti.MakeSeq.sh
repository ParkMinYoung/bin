#!/bin/sh
	## in the bustard folder
        ls *_qseq.txt | perl -nle'push @{$h{$1."_".$2}}, $_ if /(s_\d+)_\d+_(\d{4})/; }{ map { print join "\t", $_, @{$h{$_}} } sort keys %h' | perl -F'\t' -anle'$pwd=$ENV{PWD};print "qsub -N parsing ~/src/short_read_assembly/bin/sub MakeLaneSequenceNoMulti.pl --pair1 $pwd/$F[1] --pair2 $pwd/$F[2] --output-dir $pwd/Sequence\nsleep 3"' > parsing.sh
        sh parsing.sh
        perl -le'while($l=`qstat -u adminrig`){ $l=~/parsing/ ? sleep 10 : print localtime()." " & exit}'
        rm -rf parsing.{s,e,o}*

        ## merge per lane
        cd Sequence
        perl -le'map { push @{$h{$1.".".$2}}, $_ if /(s_\d+)_\d{4}\.(\d+)/  } @ARGV;END{map {print "qsub -N merge ~/src/short_read_assembly/bin/sub cat_o $_.fastq @{$h{$_}}\nsleep 20" } sort keys %h} ' *.fastq > merge.sh
        sh merge.sh
                perl -le'while($l=`qstat -u adminrig`){ $l=~/merge/ ? sleep 10 : print localtime()." " & exit}'
        rm -rf merge.{s,e,o}*
        mkdir tile
        ls s_?_????.?.fastq | xargs -i mv {} tile/
        ## delete raw data
        rm -rf tile

        ## based on lane, divide reads
        ## create s_1, s_2, ... s_8
        ## move s_[1..8].{1,2}.fastq to s_[1..8] foler ...
        ls s_?.?.fastq | perl -nle'push @{$h{$1}}, $_ if /(s_\d)\.[12]/ }{ map{ mkdir $_ if not -d $_; `mv @{$h{$_}} $_` } sort keys %h'

        ## read summary
        find s_?/ -type f | grep "1.fastq" | sort | xargs -i perl -nle'}{$r=$./4;print "$ARGV\t$r"' {} > read.summary &

        ## trim paired end read using window sliding method
        #find s_?/ -type f | sort | xargs -n 2 echo | perl -F'\s+' -anle'print localtime()."\t$_";`Trim.pl --type 2 --qual-type 1 --pair1 $F[0] --pair2 $F[1] --outpair1 $F[0].trimed --outpair2 $F[1].trimed --single $F[0].single`'
        find s_?/ -type f | sort | xargs -n 2 echo | perl -F'\s+' -anle'print "qsub -N trim ~/src/short_read_assembly/bin/sub Trim.pl --type 2 --qual-type 1 --pair1 $F[0] --pair2 $F[1] --outpair1 $F[0].trimed --outpair2 $F[1].trimed --single $F[0].single\nsleep 20"' > trim.sh
		#sh trim.sh
		#perl -le'while($l=`qstat -u adminrig`){ $l=~/trim/ ? sleep 10 : print localtime()." " & exit}'
		#rm -rf trim.{s,e,o}*

