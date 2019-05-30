fastqToCA -libraryname 20100826.s_1 -insertsize 300 50 -fastq /home/adminrig/SolexaData/Antar/raw.fastq/Q30Trim/20100826.s_1.1.fastq.Q30Trim,/home/adminrig/SolexaData/Antar/raw.fastq/Q30Trim/20100826.s_1.2.fastq.Q30Trim > 20100826.s_1.frg
gatekeeper -T -o 20100826.s_1.gkpStore 20100826.s_1.frg
gatekeeper -dumpfragments -withsequence 20100826.s_1.gkpStore

