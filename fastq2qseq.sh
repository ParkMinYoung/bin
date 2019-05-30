#!/bin/sh
perl -nle'push @l,$_; if($.%4==0){$l[0]=~/\@(.+)_(\d+):(\d+):(\d+):(\d+):(\d+)\#(\d)/;($mach,$id,$lane,$tile,$x,$y,$read_type)=($1,$2,$3,$4,$5,$6,$7);$l[1]=~s/N/\./g;$id+=0;print join "\t", $mach,$lane,$tile,$id,$x,$y,0,$read_type,$l[1],$l[3],1;@l=()}' $1 >  $1.qseq
