#!/bin/sh

source ~/.bash_function

#SNP=~/Genome/GPS.lib/region
#CHR=~/Genome/GPS.lib/chromosome
#cut -f1 $SNP | sort | uniq > $CHR

CHR=~/Genome/GPS.lib/chromosome.whole
REF=~/Genome/hg19Fasta/hg19.fasta


if [ -f "$1" ];then
	DIR=tmp.dir
	mkdir $DIR
	#for i in `cat $CHR`;do echo -e "qsub -N $i ~/src/short_read_assembly/bin/sub samtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 50 -r $i -ugf $REF -b $1 2>$DIR/$i.log > $DIR/$i\nsleep 20";done
	for i in `cat $CHR`;do echo -e "echo \"[\`date\`]\" start $i\nsamtools mpileup -D -Q 20 -q 20 -d 5000 -C 50 -o 50 -r $i -ugf $REF -b $1 2>$DIR/$i.log > $DIR/$i\necho \"[\`date\`]\" end $i\n";done > mpileup.divide.sh
	sh ./mpileup.divide.sh >& mpileup.divide.sh.log
else
	usage "bam.list"
fi
