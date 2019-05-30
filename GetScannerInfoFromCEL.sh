SC=/home/adminrig/src/short_read_assembly/bin/GetHeaderFromCel.CreatedDate.pl
for i in *.CEL; do $SC $i; done > CELFile_information

