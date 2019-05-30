#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then


	BATCH_DIR_LIST=$1
	DIR=$BATCH_DIR_LIST.Merge
	
	if [ ! -d $DIR ];then
		mkdir -p $DIR/Analysis/{BAM,FASTQ} 
	fi

	if [ ! -d queue.log ];then
		mkdir queue.log 
	fi
	

	for i in `cat $BATCH_DIR_LIST`;do find $i/Analysis/BAM -type f | egrep "(N|T)".bam$;done | \
	perl -MFile::Basename -snle'
	($f,$dir)=fileparse($_); 
	push @{$h{$f}}, $_; 
	}{
	for( sort keys %h){
		if( @{$h{$_}} ==  1 ){
			$file = $h{$_}->[0];
			print "ln $ENV{PWD}/$file $out_dir";
		}else{
			print "qsub -N bam.merge -j y -o queue.log -q high.q /home/adminrig/src/short_read_assembly/bin/sub samtools merge -f $out_dir/$_ @{$h{$_}}\nsleep 10" 
		}
	}
	' -- -out_dir=$DIR/Analysis/BAM > $DIR/01.bamMerge
	sh $DIR/01.bamMerge

	 for i in `cat $BATCH_DIR_LIST`;do find $i/Analysis/FASTQ -type f | grep fastq$;done | \
	perl -MFile::Basename -snle'
	($f,$dir)=fileparse($_); 
	push @{$h{$f}}, $_; 
	}{
	for( sort keys %h){
		if( @{$h{$_}} ==  1 ){
			$file = $h{$_}->[0];
			print "ln $ENV{PWD}/$file $out_dir";
		}else{
			print "qsub -N fastq.merge -j y -o queue.log -q high.q /home/adminrig/src/short_read_assembly/bin/sub qcat.sh $out_dir/$_ @{$h{$_}}\nsleep 10" 
		}
	}
	' -- -out_dir=$DIR/Analysis/FASTQ > $DIR/02.fastqMerge
	sh  $DIR/02.fastqMerge
	
	#SNU.BangYoungJoo.sh

else
	usage "BATCH_DIR_LIST"
fi


## [adminrig@node01 Ion.Input]$ cat SNU.BangYoungJu.DIR
## Auto_user_DL1-28-20130823-Amp.Customized.60genes.430k.set1_81_109
## Auto_user_DL0-15-20130827-Amp.Customized.60genes.430k.set1-RE_37_038
## Auto_user_DL0-16-20130904-Amp.Customized.60genes.430k.set2_38_040
