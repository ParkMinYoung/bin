#!/bin/bash 
. ~/.bash_function

#set -o history


if [ -f "$1" ] && [ -f "$2" ];then

	NORMAL=$1
	TUMOR=$2
	ID=$( basename ${TUMOR%%.*} )

	FASTA=${3:-$b37}
	GC=$FASTA.gc50Base.txt.gz
	seqz_dir=seqz

	if [ ! -f "$GC" ];then

		# execute time : 2018-11-21 21:34:18 : GC calc
		exe "sequenza-utils.py GC-windows" "/root/miniconda2/bin/sequenza-utils.py GC-windows -w 50 $FASTA  | gzip > $GC"
	
	fi


	# execute time : 2018-11-21 22:11:58 : create default $seqz_dir 
 	[[ ! -d $seqz_dir ]] && mkdir $seqz_dir && echo "create $seqz_dir folder"



	if [ ${NORMAL##*.} == "bam" ];then

		## checking whether exist normal pipleup file
		N_ID=$(basename $NORMAL .bam)
		exist_normal_pileup=$(find -type f -size -1G -name "*pileup.gz" | grep $N_ID) ## less than 1Gb

		if [ ! -f ${NORMAL%%.*}.pileup.gz ];then ## Not exist

			/home/adminrig/src/short_read_assembly/bin/sequenza.pileup.sh $NORMAL ${NORMAL%%.*}.pileup.gz &

		elif [ -f "$exist_normal_pileup" ];then  ## Low size pileup file or broken file
			
			/home/adminrig/src/short_read_assembly/bin/sequenza.pileup.sh $NORMAL ${NORMAL%%.*}.pileup.gz &
		fi
			

		exe "coverting bam to pileup format..."	"/home/adminrig/src/short_read_assembly/bin/sequenza.pileup.sh $TUMOR  ${TUMOR%%.*}.pileup.gz &"
		#BAM/SPTT_100.mergelanes.dedup.realign.recal.extract.filter.reheader.bam BAM/SPTT_100.pileup.gz

		wait

		NORMAL=${NORMAL%%.*}.pileup.gz
		TUMOR=${TUMOR%%.*}.pileup.gz
	fi

	# execute time : 2018-11-21 22:12:26 : make seqz
	exe "creating pileup2seqz file" "/root/miniconda2/bin/sequenza-utils.py pileup2seqz -gc $GC -n $NORMAL -t $TUMOR | gzip > $seqz_dir/$ID.seqz.gz"

	# execute time : 2018-11-22 14:39:30 : make small size seqz.gz
	exe "creating seqz-binning file" "/root/miniconda2/bin/sequenza-utils.py seqz-binning -w 50 -s $seqz_dir/$ID.seqz.gz | grep -v -e ^GL000 -e ^MT | gzip > $seqz_dir/$ID.small.seqz.gz"

	# execute time : 2018-11-22 14:39:30 : run sequenza package 
	exe "sequenza running" "R CMD BATCH --no-save --no-restore \"--args $seqz_dir/$ID.small.seqz.gz $ID $ID\" /home/adminrig/src/short_read_assembly/bin/R/sequenza.run.R"


else

	usage "NORMAL_(BAM|pileup.gz) TUMOR(BAM|pileup.gz) [FASTA] : TUMOR_DIR"

fi




