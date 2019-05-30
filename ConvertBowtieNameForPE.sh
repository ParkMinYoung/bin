find | grep trimed | sort | perl -MFile::Basename -nle'($f,$d)=fileparse$_;/(s_\d).(\d)/;$n="$1.trimmed_$2.fq";`mv $_ $d$n`'
