qstat -f | grep -w -e qw -e r | awk '{print $1}' | xargs -i qstat -j {} | \
perl -MMin -ane'
chomp;
if(/^job_number:\s+(.+)/){
	$job=$1
}elsif(/^sge_o_workdir:\s+(.+)/){
	$h{$job}{sge_o_workdir}=$1
}elsif(/^job_args:\s+(.+)/){
	$h{$job}{job_args}=$1
}elsif(/^hard resource_list:\s+(.+)/){
	$h{$job}{hostname} = $1
}

}{ mmfss("jobs", %h)'

