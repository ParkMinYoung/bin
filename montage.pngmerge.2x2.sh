OUTPUT=$1.png
shift
montage -font Helvetica -pointsize 20 -label %d/%f $@ -geometry 800x410 -tile 2x2 $OUTPUT

