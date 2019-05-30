#!/bin/sh

#ls $@ |
find | grep "\.gz"$ | sort |
perl -MFile::Basename -nle'
($f,$d)=fileparse($_);
$f=~/(.+)\.(1|2)\.fastq\.gz$/;
$sample=$1;
$d=~/s_\d/;
$sub_file=$&;
push @{$h{$sample}{$sub_file}}, $_;
#print "$sample\t$sub_file\t$_\t$d\t$f"
}{
print join "\n",
                       "username=minmin",
                       "api_key=fjzfwkyyil6aq3pymehc79jgjua8abeynqzmabccaaab5b9p3pa9z9aaufzc2k6l",
                       "upload_threads=10",
                       "compress_threads=6",
                       "read_threads=6",
                       "\n\n\n\n",;

for $i( sort keys %h){
       for $j( sort keys %{$h{$i}}){
               #print "$i\t$j\t@{$h{$i}{$j}}"
               print join "\n",
                         "sample",
                         "note=\"$i $j\"",
                         "name=$i",
                         "genome=hg19",
                         "experiment=resequencing",
                         "reads=$h{$i}{$j}->[0]",
                         "reads2=$h{$i}{$j}->[1]",
                         "end",
                         "\n\n",

       }
}'

# reads=./s_6/bms.raindance.samsung2.1.fastq.gz
