
#!/bin/sh

source ~/.bash_function

BIN=/home/adminrig/src/CASAVA/CASAVA1.8/bin
BCL2Fastq=configureBuild.pl
REF=/home/adminrig/Genome/fly

## for RNA Sequencing
# configureRnaBuild.pl


Script=$BIN/$BCL2Fastq

if   [ $# -eq 0 ];then
	$Script -help
elif [ -d "$1" ] && [ $# -eq 2 ];then

	InSampleDir=$1
	Out=$2
	OutDir=${Out:=CASAVA}


#JOB=$3
#J=${JOB:=8}
	

# $Script --targets all noassembleIndels --variantsSkipContigs 
	$Script --targets all noassembleIndels --variantsSkipContigs --inSampleDir=$InSampleDir --outDir=$OutDir --refSequences=$REF

else
	usage "Aligned/Project_x/Sample_x OutDir"
fi

