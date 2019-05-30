varscan.summary.sh


mkdir -p DB/{PASS,HOLD,germline}
cp cosmic.qc.output.header DB
cp excel_reports/pass/* DB/PASS/
cp excel_reports/hold/* DB/HOLD/
																			

cp ./varscan.report.files2use.pass/pharmgkb.all.txt DB/PASS/pharmgkb.somatic.txt
cp ./varscan.report.files2use.pass/genes.all.txt.e DB/PASS/genes.somatic.txt
cp ./varscan.report.files2use.pass/cosmic.all.txt DB/PASS/cosmic.somatic.txt

cp ./varscan.report.files2use.hold/pharmgkb.all.txt DB/HOLD/pharmgkb.somatic.txt
cp ./varscan.report.files2use.hold/genes.all.txt.e DB/HOLD/genes.somatic.txt
cp ./varscan.report.files2use.hold/cosmic.all.txt DB/HOLD/cosmic.somatic.txt



#GERM=/home/adminrig/workspace.jin/SNU.BYJ.proton.germline.20141121
GERM=$( pwd | sed 's/SNU.BYJ.proton.varscan/SNU.BYJ.proton.germline/' )
cp $GERM/files2use/cosmic.all.txt DB/germline/cosmic.germline.txt
cp $GERM/files2use/genes.all.txt DB/germline/genes.germline.txt
cp $GERM/files2use/pharmgkb.all.txt DB/germline/pharmgkb.germline.txt


cd DB
perl -i.bak -ple's/\.genes60//' `find PASS HOLD -type f | grep txt`
perl -i.bak -ple's/(snuh\d+)_.+genes60\t/\1\t/' `find germline HOLD -type f | grep txt`
find | grep bak$ | xargs rm 


cp `find germline -type f | grep txt$` PASS
cp `find germline -type f | grep txt$` HOLD 

find PASS HOLD | grep txt$ | xargs cut -f1 | sort | uniq

