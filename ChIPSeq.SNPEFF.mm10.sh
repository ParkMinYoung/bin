. ~/.GATKrc
java -jar /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.jar eff -i bed -config /home/adminrig/src/SNPEFF/snpEff_4_1/snpEff.config GRCm38.78 $1 > $1.SNPEFF

SNPEFF.ChIPSeq2Tab.v4.1.sh $1.SNPEFF
