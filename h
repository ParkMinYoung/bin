HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '
#history 2 | head -1 | perl -F'\s+' -asnle'print "# excute time : $F[1] $F[2] : $comment"; print join " ", @F[3..$#F],"\n\n"' -- -comment="$1" >> readme
 history 2 | head -1 | perl -snle'/(\d+-\d+-\d+ \d+:\d+:\d+) (.+)/; print "# execute time : $1 : $comment"; print $2,"\n\n"' -- -comment="$1" >> readme

#!# set -o histexpand -o history
#!# echo !-2 >> readme 

### echo !! >> readme
### echo ${_}


# fc -s 
# re-excute

# http://www.howtogeek.com/howto/44997/how-to-use-bash-history-to-improve-your-command-line-productivity/
# http://unix.stackexchange.com/questions/33794/how-can-i-alias-to-last-command
# http://stackoverflow.com/questions/6109225/bash-echoing-the-last-command-run
