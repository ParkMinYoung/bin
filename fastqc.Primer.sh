 perl -F'\t' -MMin -ane'if(/^Filename/){$f=$F[1]}elsif(/^Total Sequences/){ $h{$f}{Total} =  $F[1] }elsif(/Primer/){ $h{$f}{Count}+=$F[1]; $h{$f}{Per}+=$F[2]} }{  mmfss("out",%h)' `find | grep fastqc_data.txt$`