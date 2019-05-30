
for i in /home/adminrig/workspace.min/AFFX/211.174.205.* ; 
do 
	echo `date` dir : $i; 
	(cd $i && ls *.AUDIT *.ARR *.CEL *.DAT | perl -MMin -nle'if(/(.+_\d{6})_\w{2,3}_/){ $h{$1}++ } }{ map { print join "\t", $_, $h{$_}, get_date() if $h{$_} == 384 } keys %h' ) 
done
