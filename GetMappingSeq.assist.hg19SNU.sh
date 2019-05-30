#!/bin/sh

#SureSelectCHRBED=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.bed

 ls $@ |  
# find Samsung* | egrep "(10.gz|trimed|single|ing.bam)"$ | sort |
perl -MFile::Basename -snle'
($f,$d)=fileparse($_);
push @{$h{$d}}, $_
}{
for $i ( sort keys %h ){
	@list = @{$h{$i}};
	@list=@list[0,4,2,5,1,3];
	
	($f,$d) = fileparse($list[0]);
	$f=~/^(\w+?)_/;
	$QN="S$1";
	print "qsub -N GetMap /home/adminrig/src/short_read_assembly/bin/sub /home/adminrig/src/short_read_assembly/bin/GetMappingSeq.sh @list $target\nsleep 20"
}
' -- -target=$SureSelectCHRBED > GetMappingSeq.script
	

# ./H-100N_ACAGTG_L001_R1_001.fastq.gz.N.fastq.gz
# ./H-100N_ACAGTG_L001_R1_001.fastq.gz.N.fastq.single
# ./H-100N_ACAGTG_L001_R1_001.fastq.gz.N.fastq.trimmed
# ./H-100N_ACAGTG_L001_R1_001.fastq.gz.N.fastq.trimmed.Q23.bam.AddRG.bam.Dedupping.bam.IndelRealigner.bam.TableRecalibration.bam
# ./H-100N_ACAGTG_L001_R2_001.fastq.gz.N.fastq.gz
# ./H-100N_ACAGTG_L001_R2_001.fastq.gz.N.fastq.trimmed


