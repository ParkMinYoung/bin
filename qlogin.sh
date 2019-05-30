qlogin -l hostname=node01.local -pe orte 10
# qlogin -q em -l hostname=cp01-22.local -pe orte 32
# qsub -N test  -l hostname=cp01-1*.local ./date.SGE.sh "test" "test" test
