#!/bin/sh
. ~/.bash_function


if [ $# -eq 2 ] & [ -f "$1" ];then


defaultSummary=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.txt


PAIR=$(readlink -f $1)
PLINK=$(readlink -f $2)
DB=${3:-$defaultSummary}
DB=$(readlink -f $DB)

mkdir BlindTest && cd BlindTest

ln -s $PAIR ./
ln -s $PLINK.* ./

# IdentifiedPairs
# 1 A
# 2 B
# 3 Axio...A....CEL
# 4 Axio...B....CEL

#cut -f3,4 $PAIR > pair
cut -f1,2 $PAIR > pair

awk '{print $1"\t"$1}' pair  > A
awk '{print $2"\t"$2}' pair  > B
   
    
/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $PLINK --keep A --make-bed --out A.set --allow-no-sex --threads 5
/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $PLINK --keep B --make-bed --out B.set --allow-no-sex --threads 5

    
mv B.set.fam B.set.fam.bak
CEL2NIHfromFam.ID-Remap.sh pair B.set.fam.bak > B.set.fam

/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile A.set --bmerge B.set.bed B.set.bim B.set.fam --merge-mode 7 --out blindTest --allow-no-sex --threads 5


PlinkOut2Tab.sh blindTest.diff


cut -f2 blindTest.diff.tab | sort | uniq -c | awk '{print $2"\t"$1}' > blindTest.diff.tab.count


/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile A.set --bmerge B.set.bed B.set.bim B.set.fam --merge-mode 6 --out blindTest.missing --allow-no-sex --threads 5


PlinkOut2Tab.sh blindTest.missing.diff


perl -F'\t' -anle'if(/0\/0/){ $h{$F[1]} ++ } }{ map { print join "\t", $_, $h{$_} } sort keys %h'  blindTest.missing.diff.tab > blindTest.missing.diff.tab.NotCMPMarker

#join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep ^Axiom |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=789910 > Concordance

echo -e "CEL\tDiff\tNotCMPMarker\tTotalMarker\tConcordantRate" > Concordance

MarkerCNT=$(wc -l A.set.bim | awk '{print $1}')

# KORV1_0
#join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep -v ^FID |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=$MarkerCNT >> Concordance

# KORV1_1
join.sh blindTest.diff.tab.count blindTest.missing.diff.tab.NotCMPMarker 1 1 2 | grep -v ^FID |  perl -F'\t' -sanle'$id=$F[0]; print join "\t", $id, $F[1],$F[2],$total, (1-$F[1]/($total-$F[2])) *100' -- -total=$MarkerCNT >> Concordance

 perl -F'\t' -anle'if(@ARGV){$h{$F[0]}=$F[1]}else{ if(!$c++){ print join "\t", qw/A B Diff NotCMPMarker TotalMarker Concordance/}else{ print join "\t", $F[0],$h{$F[0]},@F[1..$#F]} }' pair Concordance  > Final.Concordance


## if ID is CELfile name, 
if [ $# -eq 4 ];then
		# excute time : 2016-10-05 13:55:36 : add A
		join.h.sh Final.Concordance $DB 1 1 "5,8,9,10,11" > add.A 
		#join.h.sh Final.Concordance /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.txt 1 1 "5,8,9" > add.A 


		# excute time : 2016-10-05 13:56:03 : add B
		join.h.sh add.A $DB 2 1 "5,8,9,10,11" > add.B 
		#join.h.sh add.A /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.txt 2 1 "5,8,9" > add.B 

else
		# excute time : 2016-10-05 13:55:36 : add A
		join.h.sh Final.Concordance $DB 1 2 "5,8,9,10,11" > add.A 
		#join.h.sh Final.Concordance /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.txt 1 1 "5,8,9" > add.A 


		# excute time : 2016-10-05 13:56:03 : add B
		join.h.sh add.A $DB 2 2 "5,8,9,10,11" > add.B 
		#join.h.sh add.A /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.txt 2 1 "5,8,9" > add.B 

fi


# excute time : 2016-10-05 14:32:15 : Add specific column names in the Header line
AddHeader.sh add.B Final.Concordance.summary.txt $(head -1 Final.Concordance | cut -f1-6) A.DQC A.CR A.HET A.X A.Y B.DQC B.CR B.HET B.X B.Y

rm -rf add.A add.B




# datamash -H mean 6 < Final.Concordance

else
		usage "PAIR PLINK Summary.txt (CEL)"
fi

