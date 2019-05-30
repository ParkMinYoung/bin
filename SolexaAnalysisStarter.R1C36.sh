        ## in the bustard folder
        ls *_qseq.txt | perl -nle'push @{$h{$1."_".$2}}, $_ if /(s_\d+)_\d+_(\d{4})/; }{ map { print join "\t", $_, @{$h{$_}} } sort keys %h' | perl -F'\t' -anle'print "qsub -N parsing ~/src/short_read_assembly/bin/sub MakeLaneSequenceNoMulti.pl --pair1 $F[1] --pair2 $F[2] --output-dir Sequence"' > parsing.sh
	    sh parsing.sh
	    perl -le'while($l=`qstat -u adminrig`){ $l=~/parsing/ ? sleep 10 : print localtime()." " & exit}'
	    rm -rf parsing.{s,e,o}*
     
        ## merge per lane
        cd Sequence
        perl -le'map { push @{$h{$1.".".$2}}, $_ if /(s_\d+)_\d{4}\.(\d+)/  } @ARGV;END{map {print "qsub -N merge ~/src/short_read_assembly/bin/sub cat_o $_.fastq @{$h{$_}}" } sort keys %h} ' *.fastq > merge.sh
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
       
