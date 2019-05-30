# https://linuxconfig.org/bash-printf-syntax-basics-with-examples

# When $SGE_TASK_ID is 1, NUM is 000.
NUM=$( printf "%03d" $(( $SGE_TASK_ID - 1 ))  )

