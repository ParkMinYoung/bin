qsub -N s_1 ~/src/short_read_assembly/bin/sub ./Bam2Tile.TrimedFastq.Tmp.sh s_1/s_1
sleep 10
qsub -N s_2 ~/src/short_read_assembly/bin/sub ./Bam2Tile.TrimedFastq.Tmp.sh s_2/s_2
sleep 10
qsub -N s_3 ~/src/short_read_assembly/bin/sub ./Bam2Tile.TrimedFastq.Tmp.sh s_3/s_3
sleep 10
qsub -N s_4 ~/src/short_read_assembly/bin/sub ./Bam2Tile.TrimedFastq.Tmp.sh s_4/s_4

