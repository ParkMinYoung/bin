Cols2Matrix.sh 1 5 DepthofCov `ls *summary | sort`
#perl -i.bak -ple'if($.==1){s/.mergelanes.dedup.realign.recal.bam.target.depthofcov.sample_interval_summary//g}' DepthofCov.txt
bs



perl -i.bak -ple'if($.==1){s/.mergelanes.realign.recal.bam.target.depthofcov.sample_interval_summary//g}' DepthofCov.txt

## All
#perl -F'\t' -anle'if(@ARGV){$k=$F[0].":".++$F[1]."-".$F[2]; $h{$k}=$F[3]}else{ if(++$c==1){print join "\t", $_, "Gene"}else{ print join "\t", $_, $h{$F[0]} } }' JaxCancerTreatmentPanel.190Genes.In.SSV3.bed DepthofCov.txt > DepthofCov.txt.GeneLabel

## Jax CTP 
#perl -F'\t' -anle'if(@ARGV){$k=$F[0].":".++$F[1]."-".$F[2]; $h{$k}=$F[3]}else{ if(++$c==1){print join "\t", $_, "Gene"}elsif($h{$F[0]}){ print join "\t", $_, $h{$F[0]}  }}' JaxCancerTreatmentPanel.190Genes.In.SSV3.bed DepthofCov.txt > DepthofCov.txt.GeneLabel

## CCP
perl -F'\t' -anle'if(@ARGV){$k=$F[0].":".++$F[1]."-".$F[2]; $h{$k}=$F[3]}else{ if(++$c==1){print join "\t", $_, "Gene"}elsif($h{$F[0]}){ print join "\t", $_, $h{$F[0]}  }}' /home/adminrig/Genome/IonAmpliSeq/CCP/CCP.bed DepthofCov.txt > DepthofCov.txt.GeneLabel

R CMD BATCH --no-save ~/src/short_read_assembly/bin/R/CCP.Gene.Heatmap.R
R CMD BATCH --no-save ~/src/short_read_assembly/bin/R/CCP.Gene.Heatmap.auto.R
R CMD BATCH --no-save ~/src/short_read_assembly/bin/R/CCP.Gene.Heatmap.1K.R

