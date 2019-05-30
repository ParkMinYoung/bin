find | grep bam$ | sort | xargs ls -l | perl -F'\s+' -MMin -MFile::Basename -ane'chomp(@F);($f,$d)=fileparse($F[8]); $f=~s/.+fastq.gz.N.fastq\.//;@bam=split "\.bam", $f; $h{$d}{$bam[-1]} = $F[4]; }{ mmfss("bam.size", %h)'

