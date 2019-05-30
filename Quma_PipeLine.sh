SAM=/home/adminrig/workspace.min/MethylSeq/KonkukUniv_KoKinam/BAM2Split/TargetGeneByAnalysis/Sample
DIR=$1-Quma


mkdir -p $DIR/{GeneFasta,Format}


# excute time : 2016-12-20 14:55:05 : make bed
tail -n +2 $1 | cut -f1-4 > $DIR/Gene.bed


cd $DIR
# excute time : 2016-12-22 15:30:15 : get fasta
GetFastaFromBed.sh Gene.bed 



# excute time : 2016-12-22 16:01:47 : Gene fasta split
(cd GeneFasta/ && ln -s ../Gene.bed.tab ./ && Fasta2subFasta.sh Gene.bed.tab)


cut -f4 Gene.bed | xargs -i mkdir Format/{} 



for i in $( cat $SAM );
    do
    perl -F'\t' -asnle'BEGIN{ $sample=~/BAM2Split\/(.+?)\//; $id=$1;}  $loc="$F[0]:$F[1]-$F[2]"; $bam="${sample}_$F[0].bam";print "samtools view -b $bam $loc > $dir/$F[3]/$id.bam"' -- -sample=$i -dir="Format" Gene.bed | sh 
done


for i in $( find Format/ -type f -name "*.bam" ); 
    do samtools view $i | perl -F'\t' -anle' $F[0]=~s/HWI-D00574:199:C9J38ANXX://; print ">$F[0]\n$F[9]"' > $i.fa
done 

