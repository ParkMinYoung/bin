        bclStart.sh >& bclStart.sh.log 
		## in the bustard folder
        ls *_qseq.txt | perl -nle'push @{$h{$1."_".$2}}, $_ if /(s_\d+)_\d+_(\d{4})/; }{ map { print join "\t", $_, @{$h{$_}} } sort keys %h' | perl -F'\t' -anle'print "qsub -N parsing ~/src/short_read_assembly/bin/sub MakeLaneSequenceNoMultiSingle.pl --single $F[1] --output-dir Sequence\nsleep 3"' > parsing.sh
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
        #rm -rf tile

        ## based on lane, divide reads
        ## create s_1, s_2, ... s_8
        ## move s_[1..8].{1,2}.fastq to s_[1..8] foler ...
        ls s_?.?.fastq | perl -nle'push @{$h{$1}}, $_ if /(s_\d)\.[12]/ }{ map{ mkdir $_ if not -d $_; `mv @{$h{$_}} $_` } sort keys %h'

        ## read summary
        find s_?/ -type f | grep "1.fastq" | sort | xargs -i perl -nle'}{$r=$./4;print "$ARGV\t$r"' {} > read.summary &
       
        ## trim paired end read using window sliding method
        #find s_?/ -type f | sort | xargs -n 2 echo | perl -F'\s+' -anle'print localtime()."\t$_";`Trim.pl --type 2 --qual-type 1 --pair1 $F[0] --pair2 $F[1] --outpair1 $F[0].trimed --outpair2 $F[1].trimed --single $F[0].single`'
        find s_?/ -type f | sort | perl -nle'print "qsub -N trim ~/src/short_read_assembly/bin/sub Trim.single.pl --type 2 --qual-type 1 --pair1 $_  --outpair1 $_.trimed \nsleep 20"' > trim.sh
		GetFastqInfo.batch.sh `find s_?/ | grep fastq$` >& GetFastqInfo.batch.sh.log
        sh trim.sh
        perl -le'while($l=`qstat -u adminrig`){ $l=~/trim/ ? sleep 10 : print localtime()." " & exit}'
		GetTrimSeq.sh &
        rm -rf trim.{s,e,o}*

        ## formatting for using bwa.auto.PairedEnd.sh
        ## symbolic link
        find s_? | grep trimed$ | perl -nle's/\.\///;$_=$ENV{PWD}."/".$_; $c=$_;s/\.fastq\.trimed//;print "$_\t$c";`ln -s $c $_`'
        #rm -rf bwa.auto.PairedEnd.sh.log

        ## paired end mapping
         #find s_? -type l | perl -nle'if(s/\.//){ $h{$_}++ }  }{ map{print localtime()."\texcute $_";`bwa.auto.PairedEnd.sh $_ 18 3 >> bwa.auto.PairedEnd.sh.log 2>&1`}sort keys %h'
        # each command
		 Target2gz.sh `find s_?/ | grep fastq$` >& Target2gz.sh.sh.log
		 mkdir summary && mv Means.txt Qscore.txt read.summary trimmed.sequences.txt summary
		 mvlog

