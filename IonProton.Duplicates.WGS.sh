samtools index $1
samtools idxstats $1 > $1.idstats
RG=$(basename $1 .bam)

AddOrReplaceReadGroups.IonProton.sh $1 $RG
MarkDuplicates.flag.sh $1.AddRG.bam
GenomeAnalysisTK.DepthOfCoverage.IonTorrent.WGS.sh $1.AddRG.bam.Dedupping.Mark.bam

