#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then

GENOME="hg19" # "b37"

LOAD=$1
IN=$2


DIR=Mismatch.$3
mkdir $DIR 

# vcf.index.sh
# perl -F'\t' -anle'if($F[2] eq "B" && $F[6] == 1){print join "\t", $F[0],$F[1]-1,$F[1]}' SNP.DP10GQ90.diff.sites > SNP.DP10GQ90.diff.sites.bed
# for i in *diff.sites ;do perl -F'\t' -anle'if($F[2] eq "B" && $F[6] == 1){print join "\t", $F[0],$F[1]-1,$F[1]}' $i > $i.bed; done
# for i in *diff.sites ;do perl -F'\t' -anle'if($F[2] == 1 ){print join "\t", $F[0],$F[1]-1,$F[1]}' $i > $i.1.bed; done
# for i in *diff.sites ;do perl -F'\t' -anle'if($F[2] == 2 ){print join "\t", $F[0],$F[1]-1,$F[1]}' $i > $i.2.bed; done


perl -F'\t' -asnle'
BEGIN{
	$genome     = "hg19";
    print "new";
	print "genome $genome";
	print "snapshotDirectory $ENV{PWD}/$dir";
}

if(@ARGV){
	print "load $_";
}else{
	$pos = "$F[0]:$F[1]-$F[2]";

	$pos2 = "$F[0].$F[1]-$F[2]";
	$loc="$F[1]-$F[2]";

	print join "\n", "maxPanelHeight 100000", "goto $pos","setSleepInterval 2000", "sort base","setSleepInterval 2000", "collapse", "snapshot $pos2.png";
#print join "\n", "maxPanelHeight 100000", "goto $pos","setSleepInterval 2000", "sort base $loc","setSleepInterval 2000", "collapse", "snapshot $pos2.png";
}
}{ 
	print "exit"
' -- -dir=$DIR $LOAD $IN  > $IN.igv.batch

#echo "/home/adminrig/src/IGV_2.1.28/igv.sh $BAM -g $GENOME -b $IN.igv.batch"
#echo "`date`check the xming"

#/home/adminrig/src/IGV_2.1.28/igv.sh -g $GENOME -b $IN.igv.batch
#/home/adminrig/src/IGV_2.3.37/igv.sh -g $GENOME -b $IN.igv.batch
/home/adminrig/src/IGV/IGV_2.3.49/igv.sh -g $GENOME -b $IN.igv.batch

else
	usage "Load_List_file Target_Bed"
fi

#maxPanelHeight 100000
#region chr4 55593083 55594695
#goto chr4:55593583-55593584
#sort base 55593583-55593595
#collapse
#snapshot chr4.55592179-55592180.100000.png

