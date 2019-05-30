for i in s_{1..8};do cut -f9 ${i}_2_????_qseq.txt | sort | uniq -c | sort -nr -k1 | head > $i.index.count ;done
# cut -f9 s_1_2_????_qseq.txt | sort | uniq -c | sort -nr -k1 | head
