source /home/adminrig/.bashrc

## get cel information : 20170405
(cd /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis && ./excute.MergeCelFileInformation.KNIH.2018.sh)

cd /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/KNIH_KORV1_Report/knih_korv1_2018


# excute time : 2016-07-27 11:45:48 : Make KNIH 001 Project Summary.txt
(head -1 /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.Gender.txt; grep DL020 /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.Gender.txt | grep -v XXX ) > Summary.txt 

## get unique list & cleanup
GetUniqSummary.sh Summary.txt
rm -rf Summary.R* Summary.txt* && mv Summary.Unique.txt Summary.txt
## 20161107 ##


join.h.sh Summary.txt /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis/KNIH.2018/CELfile_Information.Summary.KNIH.2018.txt 1 1 12 > Summary.txt.md5sum
\mv -f Summary.txt.md5sum Summary.txt

####################################################
## final step : remove lowCR, DQC, mismatch gender # 
####################################################

perl -F'\t' -anle'if($.==1){print}elsif($F[4]>=0.82 && $F[7]>=98 && ($F[13]==1 || $F[13]==4)){print}' Summary.txt > Summary.txt.bak
\mv -f Summary.txt.bak Summary.txt


/home/adminrig/src/short_read_assembly/bin/TAB2XLSX.sh Summary.txt

\cp -f ~/src/short_read_assembly/bin/R/Report/{Report.KNIH.Rmd,Report.KNIH.sh}  ./
ssh -q -x 211.174.205.69 "cd $PWD && sh Report.KNIH.sh"

\rm -rf Report.KNIH.Rmd Report.KNIH.sh log Thumbs.db
mv -f Report.KNIH.md README.md

time=$(date +'%Y-%m-%d %H:%M:%S')
git add *
git status
git commit -m "$time : update log"
#git commit -m `date` : update log
git push origin master
#git push origin +master


#(ssh -q -x 211.174.205.69 "cd /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis/KNIH.2018 && sh Lot2Output.sh")

