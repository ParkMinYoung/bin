        bclStart.sh >& bclStart.sh.log
		#mkdir Sequence
		## in the bustard folder
        ls *_qseq.txt | perl -nle'push @{$h{$1."_".$2}}, $_ if /(s_\d+)_\d+_(\d{4})/; }{ map { print join "\t", $_, @{$h{$_}} } sort keys %h' | perl -F'\t' -anle'print "qsub -N parsing ~/src/short_read_assembly/bin/sub MakeLaneSequenceNoMulti.pl --pair1 $F[1] --pair2 $F[2] --output-dir Sequence\nsleep 3"' > parsing.sh
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
        sh trim.sh
		GetFastqInfo.batch.sh `find s_?/ | grep fastq$` >& GetFastqInfo.batch.sh.log
		GetTrimSeq.sh
        perl -le'while($l=`qstat -u adminrig`){ $l=~/trim/ ? sleep 10 : print localtime()." " & exit}'
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


        ## formatting for using bwa.auto.PairedEnd.sh
        ## symbolic link
        find s_? | grep trimed$ | perl -nle's/\.\///;$_=$ENV{PWD}."/".$_; $c=$_;s/\.fastq\.trimed//;print "$_\t$c";`ln -s $c $_`'
        #rm -rf bwa.auto.PairedEnd.sh.log

        ## paired end mapping
         #find s_? -type l | perl -nle'if(s/\.//){ $h{$_}++ }  }{ map{print localtime()."\texcute $_";`bwa.auto.PairedEnd.sh $_ 18 3 >> bwa.auto.PairedEnd.sh.log 2>&1`}sort keys %h'
        # each command
        #find s_? -type l | perl -nle'if(s/\.\d//){ $h{$_}++ } }{ print " bwa.auto.PairedEnd.sh $_ 18 3 &> $_.log"}sort keys %h'
        find s_? -maxdepth 2 | perl -nle'if(s/\.[12]$//){$h{$_}++} }{ map {/(s_\d)/;print "qsub -N PE$1 ~/src/short_read_assembly/bin/sub bwa.auto.PairedEndV2.S32M2Hg19.sh $_ 32 2/nsleep 20" } sort keys %h'  > PE.sh


        sh PE.sh

        # work for single read
         #make single folder
         find . -type f | grep single$ | xargs -i dirname {} | xargs -i mkdir -p {}/single
         #make symbolic link
         find s_? -type f -name "*single" | perl -MFile::Basename -nle'$_=$ENV{PWD}."/".$_;($f,$d)=fileparse $_;`ln -s $_ $d/single`'
         #excute mapping
         #find s_? | grep "single/" | perl -nle'print localtime()."\texcute $_";`bwa.auto.SingleEnd.sh $_ 18 3 >> bwa.auto.SingleEnd.sh.log 2>&1`'
         find s_? | grep "single/" | perl -nle'/(s_\d)/; print "qsub -N SE$1 ~/src/short_read_assembly/bin/sub bwa.auto.SingleEndV2.S32M2Hg19.sh $_ 32 2/nsleep 20" ' > SE.sh
         sh SE.sh

        perl -le'print localtime()."Wait......";while($l=`qstat -u adminrig`){ $l=~/[SP]E/ ? sleep 10 : print localtime()." " & exit}'
        rm -rf s_?.{s,e,o}*
        #rm -rf SE.sh PE.sh

        ## merge PE bam and SE bam
        find s_? -type f -name "*.bam" | perl -nle'/(s_\d+)/;push @{$h{$1}}, $_ }{ map{print "samtools merge $_/$_.bam @{$h{$_}}";`samtools merge $_/$_.bam @{$h{$_}};samtools rmdup -S $_/$_.bam $_/$_.rmdup.bam; mv $_/$_.bam $_/$_.bam.bak; mv $_/$_.rmdup.bam $_/$_.bam` } keys %h'
        ## sort merged bam(PE bam and SE bam)
        #find s_? -maxdepth 1 -type f -name "*.bam$" | grep -v sai | xargs -i -t samtools sort {} {}.sorted
        ## indexing bam
        #find s_? -maxdepth 1 -type f -name "*bam.sorted.bam$" | grep -v sai | xargs -i -t samtools index {}

                find s_? | perl -nle'print "qsub -N $2 ~/src/short_read_assembly/bin/sub Bam2Tile.TrimedFastq.sh $1" if /((s_\d)\/s_\d)\.bam$/' > bam2tile.sh
                sh bam2tile.sh
                perl -le'while($l=`qstat -u adminrig`){ $l=~/s_\d/ ? sleep 10 : print localtime()." " & exit}'
                rm bam2tile.sh s_?.{s,e,o}
                #~/src/short_read_assembly/bin/GetSummary.sh


perl -le'print localtime()."Wait......";while($l=`qstat -u adminrig`){ $l=~/s_\d/ ? sleep 10 : print localtime()." " & exit}'
GetCovPerDepth.sh
GetCoverageRange.sh
GetOnOffMappedBase.sh &

