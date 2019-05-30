source /home/adminrig/.bashrc

cd /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/KNIH_KORV1_Report/2016.44K

# excute time : 2016-07-27 11:45:48 : Make KNIH 001 Project Summary.txt
(head -1 /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.Gender.txt; grep DL001 /home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/AnalysisResult/Summary.Gender.txt) > Summary.txt 

## get unique list & cleanup
GetUniqSummary.sh Summary.txt
rm -rf Summary.R* Summary.txt* && mv Summary.Unique.txt Summary.txt
## 20161107 ##

/home/adminrig/src/short_read_assembly/bin/TAB2XLSX.sh Summary.txt

\cp -f ~/src/short_read_assembly/bin/R/Report/{Report.KNIH.Rmd,Report.KNIH.sh}  ./
ssh -q -x 211.174.205.69 "cd $PWD && sh Report.KNIH.sh"

\rm -rf Report.KNIH.Rmd Report.KNIH.sh log Thumbs.db
mv -f Report.KNIH.md README.md
cd ..

time=$(date +'%Y-%m-%d %H:%M:%S')
git add *
git status
git commit -m "$time : update log"
#git commit -m `date` : update log
git push origin master
#git push origin +master

