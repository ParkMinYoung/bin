for i in `ls *AddRG.bam`;
        do

        BAM=$i.reheader.bam
        samtools view -H $i | sed "s/16569/16571/" | samtools reheader - $i > $i.reheader.bam
        samtools index $BAM

        BAI=${BAM/%bam/bai}
        echo "$BAM $BAI"
        ln -s $BAM.bai $BAI
done

