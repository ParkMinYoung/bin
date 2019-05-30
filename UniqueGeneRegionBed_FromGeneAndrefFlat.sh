
# excute time : 2016-10-13 15:39:37 : download refflat
#refFlat.download.sh 
refFlat.down.sh


# excute time : 2016-10-13 15:41:57 : get bed from gene list
GeneFromRefFlat.sh $1


# excute time : 2016-10-13 15:45:03 : get unique region
GetGeneBedFromUCSCrefFlat.sh $1.refFlat 

## output : refFlat.Gene.bed
