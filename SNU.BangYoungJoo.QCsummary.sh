. ~/.perl
## make QC count matrix file
find $(find_d 1 | grep IGV$ | grep -v COSMIC) -type f | \
grep png$ | \
xargs -i dirname {} | \
sort | \
uniq -c  | \
perl -MMin -ne'chomp;/(\d+)\s+(.+)\/(\w{1})$/; 
$h{$2}{$3}=$1; 
$h{$2}{Total} += $1 
}{ 
mmfss("QC.count",%h)'


## make cosmic QC count matrix file
find $(find_d 1 | grep IGV$ | grep COSMIC) -type f | \
grep png$ | \
perl -F"\/" -anle'
BEGIN{ 
$type{H}="suspicion";
$type{P}="validation";
$type{F}="No Mutation";
$type{C}="No Sequencing";
} 
$F[1]=~/snuh\d+/; 
$id=$&; 
$F[3]=~/(chr\w+).(\d+)-(\d+).(\w+).p.(.+).png/; 
print join "\t", $1,$2,$3,$4,$5,$id,$type{$F[2]}' > cosmic.qc.output

## make cosmic QC final file 
perl -F'\t' -anle'
BEGIN{ 
	print join "\t", qw/Chr Start End Gene AminoAcid Coding ID QC/;
} 
$k=join ":",@F[0..2]; 
if(@ARGV){
	$h{$k}=$F[5]
}else{
	print join "\t", @F[0..4],$h{$k},@F[5,6]}
' /home/adminrig/Genome/IonAmpliSeq/SNU.430/SNU.BangYoungJoo.COSMIC.snp cosmic.qc.output > cosmic.qc.output.header


