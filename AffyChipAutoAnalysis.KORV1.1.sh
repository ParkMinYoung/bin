#!/bin/bash 

. ~/.bashrc
. ~/.bash_function

WORKING_DIR=$1

# Analysis Folder Name
ANALYSIS_DIR=Analysis

# to analyze batch cel number
BATCH_CEL_NUM=90

# SCRIPT
AFFY_CHIP_SUMMARY=/home/adminrig/src/short_read_assembly/bin/AffyChipSummary.sh
APT_PROBESET_GENOTYPE=/home/adminrig/src/short_read_assembly/bin/apt-probeset-genotype.KORV1.1.sh


if [ -d "$WORKING_DIR" ];then

		# mv working directory
		cd $WORKING_DIR

		# read config file 
		if [ -f "config" ];then
		    source config
		fi


		# working
		ls *CEL | \
		perl -snle'
			# CEL file name pattern
			#/_(\w+\d+?)_\w{2,3}_/;
			#/.+_(\w+\d+)_\w{2,3}_/;
			/.+_(\d{6})_\w{2,3}_/;
			
			$set=$1;
			push @{ $h{$set} }, $_ ;
		}{ 
		for $i ( sort keys %h ){
			$target_dir = "$dir/$i/CEL";
			$target_dir_batch = "$dir/$i/batch";
			
			if( -e $target_dir ){
				@cel = `ls $target_dir/*.CEL`;
				$excute = "$dir/$i/apt-geno-qc.log";

				if( @{$h{$i}} > @cel || ! -f $excute ){
					`rm -rf $dir/$i`;
				}	

			}


			if( !-d $target_dir && @{ $h{$i} } >= $number ){

				`mkdir -p $target_dir && ln @{ $h{$i} } $target_dir`;
				print localtime()."\t$target_dir is created and moved cel files";
	            print STDERR "$apt $target_dir &> $target_dir/log &";
				
				if ( ++$batch_count % 5 == 0 ){
					print STDERR "wait";
				}


#!#				print "mkdir -p $target_dir && ln @{ $h{$i} } $target_dir";
#!#             `qsub -q utl.q -pe orte 2 -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 5`
#!#				print STDERR "qsub -q utl.q -pe orte 2 -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 5"
				
				#print "qsub -l hostname=node01.local -q high.q -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 10"
			}
		}

		' -- -number=$BATCH_CEL_NUM -dir=$ANALYSIS_DIR -apt=$APT_PROBESET_GENOTYPE >> $0.log 2> batch.script
		
		NOW=$(datenum.sh)
		sh -x batch.script &> excute_log/$NOW.log
		mv batch.script excute_log/$NOW

		sh $AFFY_CHIP_SUMMARY


else
	usage "Working_Directory_with_CEL_file[/home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync]"
fi

# for i in {2..11}; do N=$( printf "%06d" $i ); echo "apt-probeset-genotype.KORV1.1.sh Analysis/$i/CEL &> Analysis/$i.log &"; done

