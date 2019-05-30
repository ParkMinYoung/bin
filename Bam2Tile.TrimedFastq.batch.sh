#!/bin/sh
for i in `find s_? -maxdepth 1 -type d | sort`;do echo "Bam2Tile.TrimedFastq.sh $i/$i >& $i.log &";done
