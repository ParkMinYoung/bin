#!/bin/bash

# eval 
# https://mug896.gitbooks.io/shell-script/content/eval.html

show_help () {
       cat help | less
}


usage="$(basename "$0") [-h] [-a string] -- program to calculate the answer to life, the universe and everything

where:
    -h  show this help text
    -s  set the seed value (default: 42)"


while getopts "ha:" opt; do
  case $opt in
  h)
    echo "h option"
#echo "$usage" >&2
#show_help
    ;;
  a)
    echo "a option=$OPTARG"
    ;;
  ?)
	echo "$usage" >&2
	echo "?"
	exit 1;
    ;;
  *)
	echo "$usage" >&2
#show_help
	echo "*"
    exit 1;
    ;;
  esac
done

shift $((OPTIND-1))
echo "remain: $@"

# http://blog.woosum.net/archives/1232/





