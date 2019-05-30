
#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BCL2Fastq=configureAlignment.pl

Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ -d "$1" ] && [ -f "$2" ];then

	OUTDIR=Aligned
	JOB=$3
	J=${JOB:=8}
	

	$Script --EXPT_DIR $1 --OUT_DIR $OUTDIR --make $2
	cd $OUTDIR
	
	echo "Processing Dir        : $1"
	echo "Processing config.txt : $2"
	echo "Processing job count  : $J"
	echo "Output Dir            : $OUTDIR"
	
	nohup make -j $J 

else
	usage "Fastq.dir config.hiseq.B04.txt [job:8]"
fi

