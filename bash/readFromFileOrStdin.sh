
while read line
do
  echo "$line"
done < "${1:-/dev/stdin}"

https://stackoverflow.com/questions/6980090/how-to-read-from-a-file-or-stdin-in-bash

