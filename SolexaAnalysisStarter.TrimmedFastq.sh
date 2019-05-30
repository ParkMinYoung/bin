
        ## formatting for using bwa.auto.PairedEnd.sh
        ## symbolic link
        find s_? | grep trimed$ | perl -nle's/\.\///;$_=$ENV{PWD}."/".$_; $c=$_;s/\.fastq\.trimed//;print "$_\t$c";`ln -s $c $_`'
        #rm -rf bwa.auto.PairedEnd.sh.log

        ## paired end mapping
         #find s_? -type l | perl -nle'if(s/\.//){ $h{$_}++ }  }{ map{print localtime()."\texcute $_";`bwa.auto.PairedEnd.sh $_ 18 3 >> bwa.auto.PairedEnd.sh.log 2>&1`}sort keys %h'
        # each command
        #find s_? -type l | perl -nle'if(s/\.\d//){ $h{$_}++ } }{ print " bwa.auto.PairedEnd.sh $_ 18 3 &> $_.log"}sort keys %h'
		find s_? -maxdepth 2 | perl -nle'if(s/\.[12]$//){$h{$_}++} }{ map {/(s_\d)/;print "qsub -N PE$1 ~/src/short_read_assembly/bin/sub bwa.auto.PairedEndV2.S32M2Hg19.sh $_ 32 2" } sort keys %h'  > PE.sh

        sh PE.sh

        # work for single read
         #make single folder
         find . -type f | grep single$ | xargs -i dirname {} | xargs -i mkdir -p {}/single
         #make symbolic link
         find s_? -type f -name "*single" | perl -MFile::Basename -nle'$_=$ENV{PWD}."/".$_;($f,$d)=fileparse $_;`ln -s $_ $d/single`'
         #excute mapping
         #find s_? | grep "single/" | perl -nle'print localtime()."\texcute $_";`bwa.auto.SingleEnd.sh $_ 18 3 >> bwa.auto.SingleEnd.sh.log 2>&1`'
         find s_? | grep "single/" | perl -nle'/(s_\d)/; print "qsub -N SE$1 ~/src/short_read_assembly/bin/sub bwa.auto.SingleEndV2.S32M2Hg19.sh $_ 32 2" ' > SE.sh
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
