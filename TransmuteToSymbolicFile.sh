#!/bin/sh

#$ -v path
#$ -cwd
#$ -S /bin/sh
#$ -pe orte 1  
#$ -S /bin/bash
#$ -q high.q
#$ -j y


source /home/adminrig/.bashrc


# 1 extenstion args 
# 2 target directiory
# 3 origine file directory
# 4 error log


if [ $# -eq 4 ] & [ -d "$2" ] & [ -d "$3" ];then
	
	EXT=$1
	T_DIR=$2
	O_DIR=$3
	LOG=$4

	cd $T_DIR
	CWD=$PWD

	for i in `find $CWD -maxdepth 1 -mindepth 1 -type f -name "*.CEL"` `find $CWD -maxdepth 1 -mindepth 1 -type l -name "*.CEL"`;
	 
		do 
		F=$(basename $i)
		
		if [ -f "$O_DIR/$F" ]; then
			echo "ln -s $O_DIR/$F $CWD" >> $LOG.sh
		else
			echo "$F not founded"
			LogRecoder.sh ~/workspace.min/AFFX/Hard2Symbolic.log $T_DIR fail $F
			exit 1
		fi


		## counter
		(( COUNTER++ ))

	done
	
	rmdir $EXT.Backup
	mkdir $EXT.Backup && mv *.$EXT $EXT.Backup
	sh $LOG.sh
	rm -rf $LOG.sh

#	find $PWD -maxdepth 1 -mindepth 1 -type f | parallel ln -s  /microarray/Genetitan/{/} {/}
	LogRecoder.sh ~/workspace.min/AFFX/Hard2Symbolic.log $T_DIR success $COUNTER

else
	usage "Extension[CEL,TXT] Target_DIR Origin_DIR Log"
fi


# qsub -N Hard2Sym -o ~/workspace.min/AFFX/Hard2Symbolic.SGE ~/src/short_read_assembly/bin/TransmuteToSymbolicFile.sh CEL /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.SNUH.JangInJin.v1 /microarray/Genetitan Axiom_KORV1.0.SNUH.JangInJin.v1.log


# cat ../TimeCalc/KOR1.0_Analysis_Time  | cut -f1 | head -40 | xargs -i echo qsub -N Hard2Sym -o ~/workspace.min/AFFX/Hard2Symbolic.SGE ~/src/short_read_assembly/bin/TransmuteToSymbolicFile.sh CEL $KNIH/{} /microarray/Genetitan {}.log | sh


