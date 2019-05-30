
#!/bin/sh 

## Usage : time GetSamtoolsStat.sh input.bam >& input.bam.log &

## for i in ``;do echo `date` $i && time GetSamtoolsStat.sh input.bam >& input.bam.log &;done 


source ~/.bash_function

if [ -f "$1" ];then

		LINE=$(perl -le'print "="x80')

		echo $LINE
		echo File Name : [$1]
		echo $LINE

		FILE=$1
		FILEDIR=$(dirname $FILE)
		NAME=$(basename $FILE)
		DIR=$FILEDIR/SamToolsStat.$(date +%Y%m%d)
		mkdir $DIR

		echo `date` index 
		samtools index $FILE

		echo $LINE
		echo `date` idxstats 
		samtools idxstats $FILE > $DIR/$NAME.idstats

		echo $LINE
		echo `date` flagstat 
		samtools flagstat $FILE > $DIR/$NAME.flagstats

		echo $LINE
		echo `date` view -X
		samtools view -X $FILE | cut -f2 | sort | uniq -c | sort > $DIR/$NAME.StrType

		echo $LINE
		echo `date` view 
		samtools view $FILE | cut -f2 | sort | uniq -c | sort > $DIR/$NAME.NumType


		samtools view $FILE | cut -f6 | sort | uniq -c | sort -nr -k2 > $DIR/$NAME.CIGAR

		echo $LINE
else
		usage "XXXX.bam"
fi
