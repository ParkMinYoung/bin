cut -f1-4 $1 | bedtools intersect -a /home/adminrig/workspace.min/Circos/circos-tutorials-0.67/tutorials/1/genome.1Mb.bed -b stdin -c > $1.1M.count
sed 's/^/bt/' $1.1M.count > $1.1M.hist

