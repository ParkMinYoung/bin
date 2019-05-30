#!/bin/sh 

. ~/.bashrc
. ~/.bash_function

WORKING_DIR=$1

# Analysis Folder Name
ANALYSIS_DIR=Analysis

# to analyze batch cel number
BATCH_CEL_NUM=96

# SCRIPT
AFFY_CHIP_SUMMARY=/home/adminrig/src/short_read_assembly/bin/AffyChipSummary.sh
APT_PROBESET_GENOTYPE=/home/adminrig/src/short_read_assembly/bin/apt-probeset-genotype.sh

if [ -d "$WORKING_DIR" ];then

		# mv working directory
		cd $WORKING_DIR

		# read config file 
		if [ -f "config" ];then
		    . config
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

			if( !-d $target_dir && @{ $h{$i} } >= $number ){

				`mkdir -p $target_dir && ln @{ $h{$i} } $target_dir`;
				#print "mkdir -p $target_dir && ln @{ $h{$i} } $target_dir";
				print localtime()."\t$target_dir is created and moved cel files";
				`qsub -l hostname=node01.local -q high.q -pe orte 2 -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 5`
				#print "qsub -l hostname=node01.local -q high.q -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 10"
			}elsif( -e $target_dir ){
				print "$target_dir";
				@cel = `ls $target_dir/*CEL`;
				if( @{$h{$i}} > @cel ){
					
					`rm -rf $target_dir`;
					`mkdir -p $target_dir && ln @{ $h{$i} } $target_dir`;
					print localtime()."\t$target_dir is recreated and moved cel files";
					#`sh -x apt-probeset-genotype.sh $1 >& $(dirname Analysis/000001/CEL)/log &`
					`qsub -l hostname=node01.local -q high.q -pe orte 2 -N APTools -j y -e TMP -o TMP /home/adminrig/src/short_read_assembly/bin/sub $apt $target_dir && sleep 5`
#					print "Analysis : ",@cel+0;
#					print "New      : ",@{$h{$i}}+0;
#					print "$target_dir : ",@{$h{$i}}+0, " ", @cel+0;
				}
			}
		}

		' -- -number=$BATCH_CEL_NUM -dir=$ANALYSIS_DIR -apt=$APT_PROBESET_GENOTYPE >> $0.log

		sh $AFFY_CHIP_SUMMARY


else
	usage "Working_Directory_with_CEL_file[/home/adminrig/workspace.shin/gwas/Genowide6.0_96CEL.rsync]"
fi


