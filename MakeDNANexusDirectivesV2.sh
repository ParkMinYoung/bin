#!/bin/sh

#ls $@ |
find | grep "fastq\.gz"$ | sort | egrep "(GE8800|G3298|G3306|GE10077)" | 
perl -MFile::Basename -nle'
($f,$d)=fileparse($_);
$d=~/(\w+)\/$/;
$sample=$1;
$f=~/\.(\d)\.fastq.gz$/;
$sub_file=$1;
push @{$h{$sample}{$sub_file}}, $_;
#print "$sample\t$sub_file\t$_\t$d\t$f"
}{
print join "\n",
                       "username=mwseong",
                       "api_key=542h6zjbzd3p205m5jnt1ntmz5dhqa3szw2m5271z7pq6t2oql62stk3zknw1ox3",
                       "upload_threads=10",
                       "compress_threads=6",
                       "read_threads=6",
                       "\n\n\n\n",;

for $i( sort keys %h){
		$read1 = join ",", @{$h{$i}{1}};
		$read2 = join ",", @{$h{$i}{2}};

               #print "$i\t$j\t@{$h{$i}{$j}}"
               print join "\n",
                         "sample",
                         "note=\"$i sample from SMW\"",
                         "name=$i",
                         "genome=hg19",
                         "experiment=resequencing",
                         "reads=$read1",
                         "reads2=$read2",
                         "end",
                         "\n\n",

}'
