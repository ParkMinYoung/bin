#!/bin/bash

. ~/.bash_function


IN=${1:-/dev/stdin}
tmp=$$

cat $IN > $tmp
cat $tmp | cut -f -$(cat $tmp | _get_ncols.sh) 
rm -rf $tmp

