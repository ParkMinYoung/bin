#!/bin/sh
find s_? -type f | egrep "(trimed|single)"$ | xargs perl -MMin -ne'if($.%4==0){chomp;$h{$ARGV}{Sequences}+=length $_;$h{$ARGV}{Reads}++} }{ mmfss("trimmed.sequences",%h)'

