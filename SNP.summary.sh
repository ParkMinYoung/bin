#!/bin/sh

DATE=`date +%F`
DIR=SNP.analysis.$DATE
mkdir $DIR

## get candidate variation count
find s_? | grep "new." | grep input$ | sort | xargs perl -MMin -ne'$ARGV=~/(\w+)\.bam.+?(INDEL)?\.bed/; $type = $2 ? $2 : "SNP"; $h{$1}{$type}++ }{ mmfss("Var.count",%h)'


## Variation count summary
find s_? -name "*new*" | grep "Var.count.summary$"  | sort | xargs perl -F'\t' -MMin -ane'$ARGV=~/(\w+)\.bam.+?(INDEL)?\.bed.+?((On|Off)Target)/; $type = $2 ? $2 : "SNP"; $id="$1:$3:$type"; chomp @F; $h{$F[0]}{$id}=$F[1] }{ mmfss("Var.count.summary",%h)'
find s_? -name "*new*" | grep Target.Var.count.txt$ | sort | xargs -i perl -nle'}{$ARGV=~/(\w+)?\.bam.+?(INDEL)?\.bed.+?((On|Off)Target)/; $type = $2 ? $2 : "SNP"; print "$1:$type:$3\t",$.-1' {} > Var.count.divde.txt


## get on Target variation count for type
find s_? -name "*new*" | grep OnTarget.Var.count.txt$ | sort | xargs perl -F'\t' -MMin -ane'BEGIN{$common=(@ARGV/2)} chomp @F; if(/^probe/){ @head=@F;next } $ARGV=~/INDEL/;$cnt{"$F[0]:$&"}++; map{ $h{$F[0]}{$head[$_]} = $F[$_] } 1..$#F }{ map { if($cnt{$_} == $common){s/:(INDEL)?$//;%{$out{$_}} = %{$h{$_}} }  } keys %cnt; mmfss("OnTarget.Var.Common",%out)'

## get off Target variation count for type
find s_? -name "*new*" | grep OffTarget.Var.count.txt$ | sort | xargs perl -F'\t' -MMin -ane'BEGIN{$common=(@ARGV/2)} chomp @F; if(/^probe/){ @head=@F;next } $ARGV=~/INDEL/;$cnt{"$F[0]:$&"}++; map{ $h{$F[0]}{$head[$_]} = $F[$_] } 1..$#F }{ map { if($cnt{$_} == $common){s/:(INDEL)?$//;%{$out{$_}} = %{$h{$_}}} } keys %cnt; mmfss("OffTarget.Var.Common",%out)'


find s_? | grep "new." | grep input$ | sort | grep INDEL | xargs perl -F'\t' -anle'$id="$F[0]:$F[2]"; $h{$id}++ }{ map {print $_} sort keys %h' > All.INDEL.coord
perl -F'\t' -anle'if(@ARGV==1){$h{$_}++}elsif(/probe/){print}elsif($h{$F[0]}){print}' All.INDEL.coord OnTarget.Var.Common.txt > OnTarget.Var.Common.INDEL.txt
perl -F'\t' -anle'if(@ARGV==1){$h{$_}++}elsif(/probe/){print}elsif($h{$F[0]}){print}' All.INDEL.coord OffTarget.Var.Common.txt > OffTarget.Var.Common.INDEL.txt


## get common variation count
perl -F'\t' -MMin -ane'chomp@F; if(/probeset/){@col=@F; $ARGV=~/(On|Off)Target.+?(INDEL)?\.txt/;$type="$1.$2"}; @idx=grep { $F[$_]>0 } 1..$#F; map { $h{$col[$_]}{$type} ++ } @idx }{ mmfss("Var.Common.Summary",%h)' OnTarget.Var.Common.txt OffTarget.Var.Common.txt OnTarget.Var.Common.INDEL.txt OffTarget.Var.Common.INDEL.txt

## get all data
find s_? | grep Target$ | sort | xargs perl -nle'$ARGV=~/(\w+)\.bam.+?(INDEL)?\.bed.+(On|Off)/; $type = $2 ? $2 : "SNP"; print "$1\t$type\t$3\t$_"' > All.input.out.RS.DepthCnt

## get common non syn variation
perl -F'\t' -MMin -asnle'chomp@F; if( @ARGV ){ if($.==1){($i)=grep { $F[$_] eq $head } 1..$#F}else{ $h{$F[0]}++ if $F[$i]} }else{ print if $h{"$F[2]:$F[4]"} } ' -- -head='novel-CDS Nonsyn' OnTarget.Var.Common.txt All.input.out.RS.DepthCnt > OnTarget.Var.Common.NovelNonSyn
perl -F'\t' -MMin -asnle'chomp@F; if( @ARGV ){ if($.==1){($i)=grep { $F[$_] eq $head } 1..$#F}else{ $h{$F[0]}++ if $F[$i]} }else{ print if $h{"$F[2]:$F[4]"} } ' -- -head='novel-CDS Nonsyn' OffTarget.Var.Common.txt All.input.out.RS.DepthCnt > OffTarget.Var.Common.NovelNonSyn

mv Var.count.txt Var.count.summary.txt Var.count.divde.txt OnTarget.Var.Common.txt OffTarget.Var.Common.txt All.INDEL.coord OnTarget.Var.Common.INDEL.txt OffTarget.Var.Common.INDEL.txt Var.Common.Summary.txt All.input.out.RS.DepthCnt OnTarget.Var.Common.NovelNonSyn OffTarget.Var.Common.NovelNonSyn $DIR

## make bed12
#perl -F'\t' -anle'($c,$s,$e,$g,$f,$t,$cds)= @F[3,4,5,6,24,1,16]; $col= $F[9]=~/CDS EXON/ ? $F[14] ne $F[15] || $F[21] ? "255,0,0" : "0,255,0"  : "0,0,255" ; print join " ",$c,$s,$e,"$t:$g:$f:$F[23]:$F[18]:$cds",1000,"+",$s,$e,$col,1,$e-$s,0'  All.input.out.RS.DepthCnt | head -100 | sort
