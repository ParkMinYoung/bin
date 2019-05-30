#!/bin/sh
cut -f9 s_1_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_1_2.tag.count 
cut -f9 s_2_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_2_2.tag.count 
cut -f9 s_3_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_3_2.tag.count 
cut -f9 s_4_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_4_2.tag.count 
cut -f9 s_5_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_5_2.tag.count 
cut -f9 s_6_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_6_2.tag.count 
cut -f9 s_7_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_7_2.tag.count 
cut -f9 s_8_2_*qseq.txt | sort | uniq -c | sort -nr -k1.1 > s_8_2.tag.count 

