
#!/bin/sh

. ~/.bash_function

if [ $# -ge 1 ];then

for file in $@;

	do

	echo "`date` start $file"

	for i in {1..22} X Y M ;
		do echo -e "qsub -N S.chr$i ~/src/short_read_assembly/bin/sub GenomeAnalysisTK.DepthOfCoverage.WGS.subChr.sh chr$i $file\nsleep 10";
	done > $1.SGE.sh

	sh $1.SGE.sh

done

else
	usage "XXX.bam [YYY.bam ZZZ.bam]"
fi

