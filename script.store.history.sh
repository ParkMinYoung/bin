# excute time : 2016-07-28 23:51:59 : script file name
#FILE=$( who am i | perl -nle'/(pts)\/(\d+)\s+(.+) (.+) \((\d+.\d+.\d+.\d+)/; print "$3__$5__$1-$2"'  )
FILE=$( who am i | perl -nle'/(pts)\/(\d+)\s+(.+) (.+) \((\d+.\d+.\d+.\d+)/; $str="$3-$4__$5__$1-$2"; $str=~s/:/-/g; print $str' )

DIR=/home/adminrig/workspace.min/script
LOG=$DIR/$FILE

script -f $LOG

# http://webdir.tistory.com/108

