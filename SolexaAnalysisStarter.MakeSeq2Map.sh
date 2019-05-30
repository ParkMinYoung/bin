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
        perl -le'while($l=`qstat -u adminrig`){ $l=~/trim/ ? sleep 10 : print localtime()." " & exit}'
		GetTrimSeq.sh 
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


## symbolic link
#find s_? | grep trimed$ | perl -nle's/\.\///;$_=$ENV{PWD}."/".$_; $c=$_;s/\.fastq\.trimed//;print "$_\t$c";`ln -s $c $_`'
find . -type f | grep single$ | xargs -i dirname {} | xargs -i mkdir -p {}/single
find s_? -type f -name "*single" | perl -MFile::Basename -nle'$_=$ENV{PWD}."/".$_;($f,$d)=fileparse $_;`ln -s $_ $d/single`'

## paired end mapping
find s_? -maxdepth 2 | perl -nle'if(s/\.[12]$//){$h{$_}++} }{ map {/(s_\d)/;print "qsub -N PE$1 ~/src/short_read_assembly/bin/sub bwa.auto.PairedEndV2.S32M2Hg19.sh $_ 32 2\nsleep 20" } sort keys %h'  > PE.sh
sh PE.sh

## single end mapping
find s_? | grep "single/" | perl -nle'/(s_\d)/; print "qsub -N SE$1 ~/src/short_read_assembly/bin/sub bwa.auto.SingleEndV2.S32M2Hg19.sh $_ 32 2\nsleep 20" ' > SE.sh
sh SE.sh

perl -le'print localtime()."Wait......";while($l=`qstat -u adminrig`){ $l=~/[SP]E/ ? sleep 10 : print localtime()." " & exit}'
rm -rf s_?.{s,e,o}*



mkdir Group
samtools merge Group/s_1.bam ./s_1/s_1.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_1/single/s_1.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_2/s_2.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_2/single/s_2.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_2.bam ./s_3/s_3.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_3/single/s_3.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_4/s_4.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_4/single/s_4.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_4.bam ./s_7/s_7.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_7/single/s_7.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_8/s_8.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_8/single/s_8.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam
samtools merge Group/s_3.bam ./s_5/s_5.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_5/single/s_5.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_6/s_6.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam ./s_6/single/s_6.1.fastq.single.ReadFilter.sanger.fastq.sai.sam.bam.sorted.bam

cd Group
MkDIR.MV.sh
Bam2Tile.TrimedFastq.sh s_1/s_1 >& s_1.log &
Bam2Tile.TrimedFastq.sh s_2/s_2 >& s_2.log &
Bam2Tile.TrimedFastq.sh s_3/s_3 >& s_3.log &
Bam2Tile.TrimedFastq.sh s_4/s_4 >& s_4.log &



