
#!/bin/bash

. ~/.bash_function

if [ -d "$1" ];then
	

		mkdir GeneBody
		cd GeneBody

		# excute time : 2018-05-11 10:14:45 : 
		cp `find $1 | grep avg.txt$ | grep -e CGI.TE -e HCP.ICP -e UP1K.GENEBODY -e CDS.INTRON ` ./


		# excute time : 2018-01-11 17:19:18 : add NA
		perl -i -ple'$_=join "\t", $_, "NA"'  *CpG.UP1K.GENEBODY.DW1K.100bin.avg.txt  *.CpG.UP1K.UTR5.CDS.INTRON.UTR3.DW1K.100bin.avg.txt 


		# excute time : 2018-01-11 17:26:06 : add header
		sed -i '1 i\index\tvalue\ttype' *.txt


		# excute time : 2018-01-11 17:24:26 : step1
		AddRow.w.sh step1 '(.+).100bin.avg.txt' File *txt  | grep Add | sh 


		# excute time : 2018-01-11 17:28:26 : add ID
		tblmutate -e '$File=~/(.+).CpG/;$1' -l ID step1 > step2


		# excute time : 2018-01-11 17:28:54 : add Analysis
		tblmutate -e '$File=~/CpG.(.+)/;$1' -l Analysis step2 > step3


		# excute time : 2018-01-11 17:29:37 : link
		ln -s step3 Genebody.table


else

	usage "DIR"

fi

