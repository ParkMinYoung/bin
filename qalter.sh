
qstat -f | grep -w qw | awk '{print $1}' | xargs -i qalter -l hostname=node04.local {}

qstat -f | grep qw | awk '{print $1}' | sed -n '1,17'p | xargs -i qalter -l hostname=node02.local {}
qstat -f | grep qw | awk '{print $1}' | sed -n '18,34'p | xargs -i qalter -l hostname=node03.local {}
qstat -f | grep qw | awk '{print $1}' | sed -n '35,51'p | xargs -i qalter -l hostname=node04.local {}
