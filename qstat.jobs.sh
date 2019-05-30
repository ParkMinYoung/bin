qstat -f | grep APTools | awk '{print $1}' | xargs -i qstat -j {} | grep ^job_args
