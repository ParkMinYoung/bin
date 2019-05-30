cd /home/adminrig/workspace.min/AFFX/TimeCalc
ls /home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.*/Analysis/Analysis.*/batch/apt-probeset-genotype.log > log.list

perl -MDate::Parse -MDateTime -nle'
$t1=`head -2 $_ | tail -n 1 | cut -c1-19`; 
$t2=`tail -n 1 $_ | cut -c1-19`;
chomp($t1);chomp($t2);
$t1DateTime = DateTime->from_epoch( epoch => str2time( $t1 ) );
$t2DateTime = DateTime->from_epoch( epoch => str2time( $t2 ) );
$diff = $t2DateTime->subtract_datetime( $t1DateTime );
/\/Axiom_KORV1.0.(.+)\/Analysis\/Analysis.(\d+)/;
print join "\t", $1, $2, $t1, $t2, $diff->in_units('days'), $diff->in_units('hours')
' log.list | sort -nr -k2,2  > KOR1.0_Analysis_Time


