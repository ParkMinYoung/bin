

HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S '
#history 2 | head -1 | perl -F'\s+' -asnle'print "# excute time : $F[1] $F[2] : $comment"; print join " ", @F[3..$#F],"\n\n"' -- -comment="$1" >> readme
 history 2 | head -1 | perl -snle'/(\d+-\d+-\d+ \d+:\d+:\d+) (.+)/; print "# execute time : $1 : $comment"; print $2,"\n\n"' -- -comment="$1" >> readme


