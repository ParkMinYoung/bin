
 src=/home/adminrig/src/short_read_assembly/bin


 grep -v ",\*" $1 > $1.filter.vcf
 sh $src/oncotator.sh $1.filter.vcf


