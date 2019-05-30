cp /home/adminrig/src/short_read_assembly/bin/R/Report/Summary2Report.* ./
ssh -q -x 211.174.205.69 "cd $PWD && sh Summary2Report.sh"


\rm -rf Summary2Report.Rmd Summary2Report.sh 


TAB2XLSX.sh Summary.txt

WEB_DIR=$WEB/$(basename $PWD).Report

if [ ! -d "$WEB_DIR" ] ;then
	mkdir $WEB_DIR
fi

\mv -f *.png *.html Summary.txt.xlsx $WEB_DIR

