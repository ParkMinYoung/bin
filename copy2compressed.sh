#!/bin/bash 

# $1 = target dir name
# $2 = destination dir name

# usage 
# "copy2compressed.sh" [target_dir] [destination_dir]



find $1 -type d | sort | uniq | xargs -i mkdir -p $2/{}
find $1 -type d | sort | uniq | perl -snle'$f=`basename $_`;chomp $f; $f.=".tar.gz" ; $file = "$home/$dest/$_/$f"; system("cd $_ && tar czf $file `find -maxdepth 1 -not -type d` ")' -- -dest=$2 -home=$PWD

