#!/bin/sh

#ls $@ |
find | grep "\.gz"$ | sort |
perl -MFile::Basename -nle'
($f,$d)=fileparse($_);
$d=~/(\w+)\/$/;
$sample=$1;
$sub_file=substr $f,0,3;
push @{$h{$sample}{$sub_file}}, $_;
#print "$sample\t$sub_file\t$_\t$d\t$f"
}{
print join "\n",
                       "username=Woojung",
                       "api_key=co2wwggyet21h4o06slh7athoavh7had7sfs6qrpur9xf0ltwb99gavgif35cdr7",
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
