
#!/bin/sh -x

#  $1 : s_?
#  $2 : seed length [32]
#  $3 : mismatch num [2]
#  $4 : s_1/s_1.sanger.1.fastq  s_1/s_1.sanger.1.fastq.gz 
#  $5 : s_1/s_1.sanger.2.fastq  s_1/s_1.sanger.2.fastq.gz 
#  $6 : thread number [default:1]

# $1 32 2 $1/$1.sanger.1.fastq $1/$1.sanger.2.fastq $NumOfTHREAD

source $HOME/.bash_function
THREAD=1

if [ $# -lt 5 ]
then
    usage [s_?] [seed len] [mismatch num in the seed] [fastq1] [fastq2] [thread number]
fi

	echo `date` start : $@

	# map to reference using bwa
	# REF=/home/adminrig/Genome/hg19.bwa/hg19.fasta

source ~/.GATKrc

if [ -e $4 ] && [ -e $5 ];then

	# create sai
	# -l : seed len
	# -k : mismatch in seed len

	if [ $6 ];then
		THREAD=$6
	fi


	# Trim
	# --type <num>		0=standard trimming, 1=adaptive trimming, 2=windowed adaptive trimming.  Default 0
	# --qual-type <num>     0=sanger qualities, 1=illumina qualities pipeline>=1.3, 2=illumina qualities pipeline<1.3.  Default 0.
	Trim.pl --type 2 --qual-type 0 --pair1 $4 --pair2 $5 --outpair1 $4.trimed --outpair2 $5.trimed --single $4.single >& /dev/null
	
	# read hashing
	bwa.patch aln -l $2 -k $3 -t $THREAD $REF $4.trimed 2> $4.trimed.sai.log > $4.trimed.sai 
	bwa.patch aln -l $2 -k $3 -t $THREAD $REF $5.trimed 2> $5.trimed.sai.log > $5.trimed.sai 
	
	# align
	bwa.patch sampe -i $1.RG -m $1 -l PE350 -p Illumina $REF $4.trimed.sai $5.trimed.sai $4.trimed $5.trimed 2> $1/$1.GATK.sam.gz.log | gzip > $1/$1.GATK.sam.gz
	MergeSamFiles.sh $1/$1.GATK.sam.gz
	
	#gzip $4.trimed 
	#gzip $5.trimed
	#gzip $4.single

	echo `date` end   : $@
else
	usage `basename $0` [s_?] [seed len] [mismatch num in the seed] [fastq1] [fastq2]
fi

