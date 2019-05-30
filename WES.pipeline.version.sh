echo -e "sickle\t"$(sickle --version | grep version)
echo -e "bwa\t" $(bwa 2>& 1 | grep Version)
echo -e "samtools\t"$(samtools 2>&1 | grep Version)
echo -e "PICARD\t"$( grep ^PICARDPATH  ~/.GATKrc | sed 's/PICARDPATH=//')
echo -e "GATK\t"$(grep EGATK ~/.GATKrc | sed 's/#EGATK=//')