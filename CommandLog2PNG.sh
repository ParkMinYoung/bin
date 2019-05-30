source /home/adminrig/.bashrc

LOG=$(ls -t1 /var/log/cmdlog.log-*gz  | head -1)

NAME=$(basename $LOG)
OUT=${NAME%.gz}
	

# excute time : zcat /var/log/cmdlog.log-20160904.gz : new 
zcat $LOG | \
perl -ple's/: \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} /: /;' | \
perl -MMin -MFile::Basename -ne'/\((\d+.\d+.\d+.\d+)\).+:\s+(.+?) /; ($ip,$cmd)=($1,$2); ($cmd)=fileparse($cmd) if $cmd=~/\//; $h{$cmd}{Total}++ && $h{$cmd}{$ip}++ if /\[0\]$/ && $cmd=~/\w+/ }{ mmfss("cmd", %h)' 


# excute time : 
Total=$(head -1 cmd.txt | tr "\t" "\n" | wc -l) 

# excute time : Final txt 
(head -1 cmd.txt; sort -nr -k$Total,$Total cmd.txt | grep -v ^2016 | head -15) > $OUT
mv -f cmd.txt $OUT.matrix


R CMD BATCH --no-save --no-restore "--args $OUT" ~/src/short_read_assembly/bin/R/CommandLog2PNG.R

zcat $LOG | \
perl -MMin -nle'BEGIN{print join "\t", qw/date id ip/} /(.+) dlfrontend (\w+):.+\((.+)\)/; ($str,$id,$ip)=($1,$2,$3); print join "\t", ThreeMonthStr_Day2YMD($str,"-"), $id, $ip if $ip=~/\d+\.\d+\.\d+\.\d+$/' > timePerIP 


# excute time : 2016-09-08 01:08:41 : R script
R CMD BATCH --no-save ~/src/short_read_assembly/bin/R/TypingFreq.R 
rename Typing $OUT.Typing Typing*.png TypingFreq.Rout 


cp -f $OUT*.png /home/adminrig/workspace.min/DNALink/AffyChip/BI_Top15_CMD
mv -f $OUT* CommandLog2PNG.Rout Analysis/


