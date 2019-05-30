#!/bin/sh

 for i in `cat $1`; do [ ! -f "$i" ] && echo $i;done
