
SC=/home/adminrig/src/short_read_assembly/bin/GetHeaderFromCel.CreatedDate.pl
for i in 0?????; do (cd $i/CEL && for j in *.CEL; do $SC $j; done > CELFile_information);  done 


