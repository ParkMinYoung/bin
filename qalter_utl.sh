
qstat -f | grep qw | grep fastq | awk '{print $1}' | xargs qalter -q utl.q

