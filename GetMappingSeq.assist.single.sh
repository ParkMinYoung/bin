#!/bin/sh


 ls $@ |  
# find Samsung* | egrep "(10.gz|trimed|single|ing.bam)"$ | sort |
perl -MFile::Basename -nle'
($f,$d)=fileparse($_);
push @{$h{$d}}, $_
}{
for $i ( sort keys %h ){
	@list = @{$h{$i}};
	@list=@list[0,2,1];
	
	($f,$d) = fileparse($list[0]);
	$f=~/^(\w+?)_/;
	$QN="S$1";
	print "qsub -N GetMap /home/adminrig/src/short_read_assembly/bin/sub /home/adminrig/src/short_read_assembly/bin/GetMappingSeq.single.sh @list\nsleep 20"
}
' > GetMappingSeq.script
	

# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.trimmerF10L10.gz
# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.trimmerF10L10.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.trimmerF10L10.single
# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R1_001.fastq.gz.trimmerF10L10.trimed
# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R2_001.fastq.gz.trimmerF10L10.gz
# Samsung1-DHA/Samsung1-DHA_TGACCA_L007_R2_001.fastq.gz.trimmerF10L10.trimed

# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R1_001.fastq.gz.trimmerF10L10.gz
# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R1_001.fastq.gz.trimmerF10L10.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R1_001.fastq.gz.trimmerF10L10.single
# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R1_001.fastq.gz.trimmerF10L10.trimed
# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R2_001.fastq.gz.trimmerF10L10.gz
# Samsung2-JHA/Samsung2-JHA_GCCAAT_L007_R2_001.fastq.gz.trimmerF10L10.trimed

# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R1_001.fastq.gz.trimmerF10L10.gz
# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R1_001.fastq.gz.trimmerF10L10.gz.bam.sorted.bam.AddRG.bam.TableRecalibration.bam.IndelRealigner.bam.Dedupping.bam
# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R1_001.fastq.gz.trimmerF10L10.single
# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R1_001.fastq.gz.trimmerF10L10.trimed
# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R2_001.fastq.gz.trimmerF10L10.gz
# Samsung3-SWA/Samsung3-SWA_CTTGTA_L007_R2_001.fastq.gz.trimmerF10L10.trimed
# 
