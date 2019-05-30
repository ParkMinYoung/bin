#!/bin/sh
for i in `find $PWD/s_? | grep trimed$`;do ln -s $i ${i%.trimed};done
