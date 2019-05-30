samtools index $1
samtools idxstats $1 > $1.idstats
samtools flagstat $1 > $1.flagstats

RG=$(basename $1 .bam)

AddOrReplaceReadGroups.IonProton.sh $1 $RG
GenomeAnalysisTK.DepthOfCoverage.IonTorrent.SNU.430k.Pool1.sh $1.AddRG.bam
GenomeAnalysisTK.DepthOfCoverage.IonTorrent.SNU.430k.Pool2.sh $1.AddRG.bam


