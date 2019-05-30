#!/bin/sh


. ~/.bash_function

if [ -f "$1" ];then

head -10000 $1 | grep ^#CHR | cut -f10- | tr "\t" "\n" > $1.ID

for i in `cat $1.ID`;
	do echo -e "qsub -N Eval `which sub` GenomeAnalysisTK.VariantEval.V3 $1 $i\nsleep 15";
done > 01.Eval.sh

sh 01.Eval.sh
waiting Eval


else
	usage "xxx.vcf"
fi


