RG=$(basename $1 .bam)

AddOrReplaceReadGroups.IonProton.sh $1 $RG
./GenomeAnalysisTK.DepthOfCoverage.IonTorrent.Target.sh $1.AddRG.bam
