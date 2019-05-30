#!/bin/sh

source ~/.bash_function


if [ $# -eq 2 ] && [ -f "$1" ] && [ -f "$2" ];then


		if [ ! -f "$1.bai" ];then
			# index bam
			samtools index $1
		fi


		SPAN=2000


perl -F'\t' -asnle'BEGIN{$output=substr($file,0,3).".extract";
$tmpdir=$$.".bam";mkdir $tmpdir} 
$id=$F[1];
($s,$e)=($F[4]-$span,$F[5]+$span);
$region="$F[2]:$s-$e";
$out="$tmpdir/$file.$id.bam";
print "samtools view -b -o $out $file $region\nsamtools sort $out $out.sort";
push @bam, $out;
push @sort, "$out.sort.bam";
}{ print "samtools merge $output.bam @sort\nsamtools sort $output.bam $output.bam.sort\nsamtools index $output.bam.sort.bam";
' -- -file=$1 -span=$SPAN $2 | sh  

# unlink <$tmpdir/*>;rmdir "$tmpdir"
else
	usage "sorted.bam Extracted.refGenes.txt"
fi


# sort bam
# samtools sort $1 $1.sort

# samtools view -o out.bam s_1.bam.NoMQ.sorted.bam chr14:73603142-73690399


