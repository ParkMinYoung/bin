#!/bin/sh

. ~/.bash_function

DATE=$(date +%Y%m%d)

TargetFolder=$1
BackupFolder=$2



if [ $# -eq 2 ];then

		if [ ! -d "$TargetFolder/CompleteBackup" ];then
			mkdir -p $TargetFolder/CompleteBackup
		fi

		if [ ! -d "log" ];then
			mkdir log
		fi

		#rsync -avz $TargetFolder/ $BackupFolder/
		(cd $TargetFolder && ls *.AUDIT *.ARR *.CEL *.DAT | perl -MMin -nle'if(/(.+_\d{6})_\w{2,3}_/){ $h{$1}++ } }{ map { print join "\t", $_, $h{$_}, get_date() if $h{$_} == 384 } keys %h' ) >> BackupDB


		# find $TargetFolder -maxdepth 1 -type f | xargs -i basename {} | rsync -avz --files-from=- $TargetFolder $BackupFolder

		for i in `grep $DATE BackupDB | cut -f1 | sort | uniq `; 
			do ls $TargetFolder/$i* | xargs -i basename {}
		done | rsync -avz --files-from=- $TargetFolder $BackupFolder >& rsync.$DATE


		#ls $TargetFolder/$(grep $DATE BackupDB | cut -f1 | sort | uniq)
		(cd $TargetFolder/ && md5sum $(grep $DATE ../BackupDB | cut -f1 | sort | uniq)* ) > md5sum
		(cd $BackupFolder/ && md5sum -c ../md5sum) | grep OK | cut -d":" -f1 > CompleSyncFile.$DATE 
		(cd $TargetFolder/ && cat ../CompleSyncFile.$DATE | xargs -n 100 -i mv {} CompleteBackup)

		mv md5sum md5sum.$DATE

		tar czf $DATE.log.tgz *.$DATE
		rm -rf *.$DATE 
		mv -f $DATE.log.tgz log

else
		usage "TargetFolderName BackupFolderName"
fi

