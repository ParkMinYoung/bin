perl -F'\t' -MMin -ane'chomp@F; $k= join "\t", @F[0..13,15..30,37,38]; $ARGV=~/((\w+)_(\w+_\w+)).simple/; $id=$2;  if($.==1){$header=$k}else{ next if /^total/;  $h{$k}{$1}++; $h{$k}{Total}++ } }{ mmfss_header($id, $header, %h)' $@
# 012_*


