OUTPUT=NGSPLOT
mkdir $OUTPUT
find $PWD | grep aligned.bam$ | perl -snle'/(.+)\/(.+?)\/aligned.bam/;$dir=$1;$id=$2;$bam="$dir/$ngs/$id.bam"; $bai="$dir/$ngs/$id.bam.bai"; print "ln $_ $bam; ln $_.bai $bai"' -- -ngs=$OUTPUT | sh

cd $OUTPUT
find $PWD -type f | grep bam$  | sort  | perl -nle'/.+\/(.+?)\.bam/; print join "\t", $_, -1, $1' > config.txt

ngs.plot.r -G bosTau6 -R genebody -C config.txt -O genebody -FL 300 -L 3000 -T mRNA.Library



