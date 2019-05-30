

FASTQ=$1
FLAG=$2

READ=$(zcat $FASTQ | head -4 | sed -n '2~4p'  | head -1)
LENREAD=$(echo ${#READ})
NUMREAD=$(zcat $FASTQ | sed -n '2~4p' | wc -l)
NUMBASES=$(expr $NUMREAD \* $LENREAD )

#LENREAD=51             
#NUMREAD=246225804      
#NUMBASES=3139379001     




perl -snle'
if(/(\d+) \+ 0 in total/){
	$mtotal=$1;
}elsif(/(\d+) \+ 0 duplicates/){
	$mdup=$1;
}elsif(/(\d+) \+ 0 mapped/){
	$mmapped=$1;
}

}{

print join "\t", "01.READLEN", $lenread;
print join "\t", "02.NUMREAD", $numread;
print join "\t", "03.NUMBASES", $numbases;
print join "\t", "04.MTOTAL", $mtotal;
print join "\t", "05.MMAPPED", $mmapped;
print join "\t", "06.MDUP", $mdup;
print join "\t", "07.MMAPPED_PER", $mmapped/$mtotal*100;
print join "\t", "08.MDUP_PER", $mdup/$mmapped*100;


' -- -lenread=$LENREAD -numread=$NUMREAD -numbases=$NUMBASES $FLAG > $FASTQ.summary


