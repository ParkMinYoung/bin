#!/bin/sh

#find Project_KNIH.set* | grep bam$ | egrep -v "(P|S)E" | 
find  | grep bam$ | egrep -v "(P|S)E" | 
perl -MFile::Basename -MMin -ne'
BEGIN{
		%map = ( gz         => "01.bam",
				 sorted     => "02.sorted.bam",
				 AddRG      => "03.AddRG.bam",
				 TableRecalibration => "04.TableRecalibration.bam",
				 IndelRealigner     => "05.IndelRealigner.bam",
				 Dedupping          => "06.Dedupping.bam",
				 sum				=> "07.Total",
				)
}
($f,$d)=fileparse($_); 
/(\w+)?\.bam$/;
$h{$d}{$map{$1}}++;
$h{Total}{$map{$1}}++;
$h{$d}{$map{sum}}++;
$h{Total}{$map{sum}}++ if $1 eq "Dedupping";

}{
mmfss("bam.matrix",%h)'

# probeset_id     AddRG   Dedupping       IndelRealigner  TableRecalibration      gz      sorted
# Project_KNIH.set1/Sample_VP02226/       0       0       0       0       1       1
# Project_KNIH.set1/Sample_VP02696/       1       0       0       0       1       1
# Project_KNIH.set1/Sample_VP02952/       1       1       1       1       1       1
# Project_KNIH.set1/Sample_VP03160/       1       0       0       0       1       1
# Project_KNIH.set1/Sample_VP04173/       0       0       0       0       1       1
