
perl -F'\t' -anle'if($.==1){print}elsif(!/^(sample|Total)/){print}' *AddRG.bam*sample_summary > DepthCoverage.sample_summary

perl -F'\t' -anle'if($.==1){map { s/\%_bases_above_//; }@F; @h=@F;print join "\t", qw/id depth value/}else{ ($id)=split "\/",$F[0]; map{print join "\t", $id, $h[$_], $F[$_]  } 6..$#F }' DepthCoverage.sample_summary > DepthCoverage.sample_summary.table

R CMD BATCH ~/src/short_read_assembly/bin/DepthCoverage.sample_summary.R

