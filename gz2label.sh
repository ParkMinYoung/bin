perl -F'\t' -MFile::Basename -anle'if(@ARGV){
	$h{$F[0]}=$F[1]
}else{
	($name,$path)=fileparse($_);
	$name=~/(.+)\.[12]\.fastq/;
	$match=$1;
	$name=~s/$match/$h{$match}/;
	$name=~s/\.gz//;
	print "zcat $_ > $name"
}' label gz.file > gunzip.batch.sh


###### label
# 34-68   s_1
# 34      s_2
# 37      s_3
# G2325   s_4
# SNUH.24-53      s_5


##### gz.file
# /isilon/GAIIx/110225_ILLUMINA-CD89F7_00025_FC_NEW22.Sequence/multiplex.2.3.4.5.6Lane/s_2/34-68.1.fastq.gz
# /isilon/GAIIx/110225_ILLUMINA-CD89F7_00025_FC_NEW22.Sequence/multiplex.2.3.4.5.6Lane/s_2/34-68.1.fastq.single.gz
# /isilon/GAIIx/110225_ILLUMINA-CD89F7_00025_FC_NEW22.Sequence/multiplex.2.3.4.5.6Lane/s_2/34-68.1.fastq.trimed.gz
# /isilon/GAIIx/110225_ILLUMINA-CD89F7_00025_FC_NEW22.Sequence/multiplex.2.3.4.5.6Lane/s_2/34-68.2.fastq.gz
# /isilon/GAIIx/110225_ILLUMINA-CD89F7_00025_FC_NEW22.Sequence/multiplex.2.3.4.5.6Lane/s_2/34-68.2.fastq.trimed.gz

