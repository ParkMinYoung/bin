#!/bin/sh

. ~/.bash_function


DP="1,5,10,15,20,25,30,40,50,60,70,80,90,100"
GQ="1,10,20,30,40,50,60,70,80,90,99"
cwd=$PWD

if [ -f "$1" ] && [ $# -ge 2 ];then

		VCF=$(readlink -f $1)
		DIR=$2
		DPs=${3-$DP}
		GQs=${4:-$GQ}


		IN=$VCF
		#TMP=queue.log
		#SUB=/home/adminrig/src/short_read_assembly/bin/sub.93

		[ ! -d $DIR ] && mkdir -p $DIR 

#		ln -s $(readlink -f $VCF) $DIR/$IN

		cd $DIR


		# by sample

		#for i in $(head -1000 1st.vcf | grep ^#CHR | cut -f10- | tr "\t" "\n");do echo -e "qsub -N extract -q utl.q -j y -o $TMP/ $SUB $src/vcftools.extract.sample.sh $IN $i 0 0\nsleep 2";done > 01.vcftools.extract

		#sh 01.vcftools.extract
		#waiting extract

		#perl -i.bak -ple's/FORMAT\t.+$/FORMAT\tA/ if /^#CHR/' `find -type f | grep vcf$` 

		for i in $(head -1000 $IN | grep ^#CHR | cut -f10- | tr "\t" "\n")
			do 
			echo "vcftools.extract.sample.sh $IN $i 0 0"
			vcftools.extract.sample.sh $IN $i 0 0
		done 




		# simulation


		for i in $(find -type f -name "*.vcf" );
			
			do
			for DP in $(echo $DPs | tr "," " ") 
				
				do
				for GQ in $(echo $GQs | tr "," " ")
					
					do
					NAME=${i%.recode.vcf}.$DP.$GQ
					vcf=$NAME.recode.vcf

					vcftools --vcf $i --minGQ $GQ --minDP $DP --maxDP 10000 --out $NAME --recode # --recode-INFO-all
					grep -v "\.\/\." $vcf > $vcf.nocall_remove
					\mv -f $vcf.nocall_remove $vcf
					vcftools --vcf $vcf --plink --out $NAME
					plink2 --file $NAME --make-bed --out $NAME --allow-no-sex --threads 1

				done
			done
		done


		perl -F'\s+' -i -aple'$ARGV=~/(.+)\.fam/; $id=$1; $_= join " ", $id, $id, @F[2..$#F]' *fam

		plinkMerge.sh ./

		cd plinkMerge
		PairwiseCalcConcordantRateFromPlink_Same_DP_GQ.sh MergePlink

#PairwiseCalcConcordantRateFromPlink.sh MergePlink

#		ln -s $PWD/ConcordantRate $cwd

	
else 
	usage "XXX.vcf OUTPUT_DIR DP[1,5,10,15,20,25,30,40,50,60,70,80,90,100] GQ[1,10,20,30,40,50,60,70,80,90,99]"
fi

