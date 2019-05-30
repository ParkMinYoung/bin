#!/bin/sh


source ~/.bash_function


if [$# -ge 4] && [ -f "$2" ] && [ -f "$3" ];then

	# demultiplex.pl --input-dir $PWD --output-dir demultiplex.KAIST --sample-sheet KAIST.20110310.10sTo2Lane.csv --mismatches 1 --correct-errors --alignment-config KAIST.20110310.10sTo2Lane.config.template.txt -qseq-mask Y101I6n
	demultiplex.pl --input-dir $PWD --output-dir $1 --sample-sheet $2 --mismatches 1 --correct-errors --alignment-config $3 -qseq-mask $4
	cd $1
	shift;shift;shift;shift

	nohup make -j 8 $@ ALIGN=yes &

	for i in `find 0?? -maxdepth 0 -type d`;do echo $i && cd $i;make >& $i.make.log;cd ..;done
	#for i in `find 010 -maxdepth 0 -type d`;do echo $i && cd $i;make >& $i.make.log;cd ..;done
	#for i in `find 00{3..9} -maxdepth 0 -type d`;do echo $i && cd $i;make >& $i.make.log;cd ..;done

	sub.demulti.GERALD.batch.sh

else
	usage "demultiplex.KAIST[output_dir] KAIST.20110310.10sTo2Lane.csv[samplesheet.csv] KAIST.20110310.10sTo2Lane.config.template.txt[config.txt] Y101I6n[qseq_format] [s_[1-8]]"
fi


