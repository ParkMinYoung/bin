for i in $@;do echo -ne "$i\t"; samtools view -H $i | grep illumina;done | cut -f1-3 > GroupID
