OUTPUT=$1.png
shift
montage -font Helvetica -pointsize 20 -label %f $@ -geometry 800x410 -tile 2x5 $OUTPUT

