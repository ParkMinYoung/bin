#!/bin/sh


perl -nle'BEGIN{@l=(34..37,40,48,49,78..79,82..91); @h{@l}=(1)x@l}push @line,$_;if($.%4==0){@n=split ":",$line[0];print join "\n", @line if !$h{$n[2]} ;@line=()}' s_1/s_1.2.fastq > s_1/s_1.2.79.fastq &
perl -nle'BEGIN{@l=(30..38,42..48,56,58,78,87..89); @h{@l}=(1)x@l}push @line,$_;if($.%4==0){@n=split ":",$line[0];print join "\n", @line if !$h{$n[2]} ;@line=()}' s_2/s_2.2.fastq > s_2/s_2.2.79.fastq &

perl -nle'BEGIN{@l=(31..32,34..37,40,78..79,81..91); @h{@l}=(1)x@l}push @line,$_;if($.%4==0){@n=split ":",$line[0];print join "\n", @line if !$h{$n[2]} ;@line=()}' s_1/s_1.2.fastq > s_1/s_1.2.137.fastq &
perl -nle'BEGIN{@l=(29..40,42..48,56,58,78..79,84..91); @h{@l}=(1)x@l}push @line,$_;if($.%4==0){@n=split ":",$line[0];print join "\n", @line if !$h{$n[2]} ;@line=()}' s_2/s_2.2.fastq > s_2/s_2.2.137.fastq &




