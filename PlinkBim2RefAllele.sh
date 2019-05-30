
# convert plink bim to tab
awk '{print $1"\t"$4"\t"$2"\t"$5"\t"$6} ' $1 > $1.tab

# correct number style chr to chr style 
perl -F'\t' -anle'BEGIN{ @h{(23,24,25,26)}=("X","Y","X","M") }  $F[0]= $h{$F[0]} ?  $h{$F[0]} : $F[0]; print join "\t", @F' $1.tab > $1.CorrectedSexChr

# get Fasta information
/home/adminrig/src/short_read_assembly/bin/Tab2VCFformat.sh $1.CorrectedSexChr


# get reference allele
perl -F'\t' -anle'
BEGIN{
    print join "\t", qw/chr bp rsid ref alt/;
}
if(@ARGV){
    /(chr\w+):\d+-(\d+)/;
    $h{"$1:$2"} = $F[1];
}else{
    $ref = $h{"$F[0]:$F[1]"};
    $alt = $ref eq $F[3] ? $F[4] : $F[3];

    print join "\t", @F[0..2], $ref,$alt;
}' $1.CorrectedSexChr.bed.fasta $1.CorrectedSexChr > $1.CorrectedSexChr.RefAllele



