#!/bin/sh

source ~/.bashrc
source ~/.bash_function

DATE=$(date +%Y%m%d)

TargetFolder=$1
BackupFolder=$2

BackupFile=$PWD/BackupDB.$TargetFolder

RSYNC_LOG=$PWD/rsync.$TargetFolder.$DATE
COMPLETE_SYNC_LOG=$PWD/CompleSyncFile.$TargetFolder.$DATE
MD5SUM=$PWD/md5sum.$TargetFolder.$DATE

echo `date` `pwd` $@ >> /home/adminrig/workspace.min/AFFX/AxiomBackup.sh.log

if [ $# -eq 2 ];then

		if [ ! -d "$TargetFolder/CompleteBackup" ];then
			mkdir -p $TargetFolder/CompleteBackup
		fi

		if [ ! -d "log" ];then
			mkdir log
		fi

		echo `date` `pwd` $@ start >> /home/adminrig/workspace.min/AFFX/AxiomBackup.sh.log

		#rsync -avz $TargetFolder/ $BackupFolder/
		(cd $TargetFolder && ls *.AUDIT *.ARR *.CEL *.DAT | perl -MMin -nle'if(/(.+_\d{6})_\w{2,3}_/){ $h{$1}++ } }{ map { print join "\t", $_, $h{$_}, get_date() if $h{$_} == 384 } keys %h' ) >> $BackupFile 

		## Handler : Not exist Rsync File
		if ! grep $DATE $BackupFile  ;then
			exit;
		fi

		# find $TargetFolder -maxdepth 1 -type f | xargs -i basename {} | rsync -avz --files-from=- $TargetFolder $BackupFolder

		for i in `grep $DATE $BackupFile | cut -f1 | sort | uniq `; 
			do ls $TargetFolder/$i* | xargs -i basename {}
		done | rsync -avz --files-from=- $TargetFolder $BackupFolder >& $RSYNC_LOG


		#ls $TargetFolder/$(grep $DATE BackupDB | cut -f1 | sort | uniq)
#		(cd $TargetFolder/ && for i in  $(grep $DATE $BackupFile | cut -f1 | sort | uniq); do md5sum $i*.CEL; done ) > $MD5SUM
		(cd $TargetFolder/ && for i in  $(grep $DATE $BackupFile | cut -f1 | sort | uniq); do md5sum $i*; done ) > $MD5SUM
		(cd $BackupFolder/ && md5sum -c $MD5SUM) | grep OK | cut -d":" -f1 > $COMPLETE_SYNC_LOG
		(cd $TargetFolder/ && cat $COMPLETE_SYNC_LOG | xargs -n 100 -i mv {} CompleteBackup)
		(cd $BackupFolder/ && cat $COMPLETE_SYNC_LOG | xargs -n 100 -i mv {} /microarray/Genetitan )


		tar czf $DATE.$TargetFolder.log.tgz *.$TargetFolder.$DATE
		rm -rf *.$TargetFolder.$DATE
		\mv -f $DATE.$TargetFolder.log.tgz log/


else
		usage "TargetFolderName BackupFolderName"
fi

## Get Status
# for i in 211.174.205.* ; do echo $i; (cd $i && ls *.AUDIT *.ARR *.CEL *.DAT | perl -MMin -nle'if(/(.+_\d{6})_\w{2,3}_/){ $h{$1}++ } }{ map { print join "\t", $_, $h{$_}, get_date() if $h{$_} == 384 } keys %h' ); done

## Clean file created after Washing prcess
# find 211.174.205.* -type f | grep GT96_ProcessTest  | xargs rm

## Check CEL files
# for i in `cut -f1 BackupDB.211.174.205.*`; do echo -ne $i : ; (cd Axiom_KORV1.0 && ls $i*.CEL | wc -l ) ; done

