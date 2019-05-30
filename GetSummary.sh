#!/bin/sh

#  $1 : Seqeuncing Directory 

source $HOME/.bash_function

if [ $# -eq 1 ]
then
    usage [s_?] 
fi

TILE=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.hg19.bed
DATE=`date +%F`
DIR=Summary.analysis.$DATE
mkdir $DIR 

## get s_?_?_????_qseq.txt handle
ls ../*qseq.txt | xargs -i perl -nle'if($.==1){@F=split "\t",$_;$l=length $F[9];} /1$/ ? $p++ : $f++; }{ print join "\t", $ARGV, $p,$f,$p+$f,$p*$l,$f*$l,($p+$f)*$l' {} > qseq.summary

## get read pass/fail summary per lane
perl -F'\t' -MMin -ane'chomp @F; /(s_(\d))_(\d)_(\d{4})/;  $f{$3}++;  $h{$1}{"PassRead"}+=$F[1];  $h{$1}{"FailRead"}+=$F[2];  $h{$1}{PassSeq}+=$F[4];  $h{$1}{FailSeq}+=$F[5]  }{   if($f{3}){map { $h{$_}{PassRead}-=$h{$_}{PassRead}/3;$h{$_}{FailRead}-=$h{$_}{FailRead}/3 } keys %h}  mmfss("qseq.lane.summary",%h)' qseq.summary


 #find s_?/ -type f | grep -e trimed$ -e single$ | xargs perl -MMin -ne'if($.%4==0){$ARGV=~/(s_\d+)/;$h{$1}{Read}++;$h{$1}{Seq}+=length($_)} }{ mmfss("sample.trim.summary",%h)'
 find s_?/ -type f | grep Dist$ | xargs perl -F'\t' -MMin -ane'$ARGV=~/(s_\d+)/;$h{$1}{Read}+=$F[1];$h{$1}{Seq}+=$F[0]*$F[1] }{ mmfss("sample.trim.summary",%h)'
 find s_?/ | grep "map$" | grep -v sanger | grep map$ | xargs perl -F'\t' -MMin -ane'$h{$ARGV}{Read}++;$h{$ARGV}{Seq}+=$F[2]-$F[1]+1 }{ mmfss("mapping.summary",%h)'



 ## batch mode
 find s_? | grep map$ | grep -v sanger | perl -nle'/(s_\d+)/; $n=$1;print "$1"; `intersectBed -a $_ -b $TILE -wa > $_.In`'
 ## cluster mode
 # find s_? | grep map$ | grep -v sanger | perl -nle'/(s_\d+)/; $n=$1; print "qsub -N $1 ./sub.intersect.wa intersectBed $_ ~/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed"'

 ## get mapping in tile 
 find s_?/ | grep "map.In$" | xargs perl -F'\t' -MMin -ane'$h{$ARGV}{Read}++;$h{$ARGV}{Seq}+=$F[2]-$F[1]+1 }{ mmfss("mappingInTile.summary",%h)'

 ## get summary information
  perl -F'\t' -MMin -ane'chomp(@F);/(s_\d+)/;if(@ARGV==3 && $1){ $h{$1}{$ARGV."-Fail"} = $F[2]; $h{$1}{$ARGV."-Pass"} = $F[4]; $h{$1}{$ARGV."-Total"} = $F[2]+$F[4] } elsif( $1 ) { $h{$1}{$ARGV}=$F[2] } }{ mmfss("Summary",%h)' qseq.lane.summary.txt sample.trim.summary.txt mapping.summary.txt mappingInTile.summary.txt
 ## get length coverage
 find | grep "intersect.txt" | xargs  perl -F'\t' -MMin -ane'$ARGV=~/(s_\d)/; $lane=$1; if(/^chr/) { $h{$lane}{Sequencing}+=$F[2]; $h{$lane}{Total}+=$F[4]; $h{$lane}{Intersect}+=$F[1]}  }{  map { $h{$_}{Efficiency} = sprintf "%2.2f", $h{$_}{Intersect}/$h{$_}{Total}*100 } keys %h; mmfss("efficiency.summary",%h)'

## get coverage summary
find s_? | grep "DepthVsCov.txt" | xargs perl -F'\t' -MMin -ane'$ARGV=~/(s_\d)/;$l=$1;if(/^\d/){$h{$F[0]}{$l}=$F[1]} }{ mmfsn("coverage.summary",%h)'

mv qseq.summary qseq.lane.summary.txt sample.trim.summary.txt mapping.summary.txt mappingInTile.summary.txt Summary.txt efficiency.summary.txt coverage.summary.txt $DIR

post.analysis.sh

