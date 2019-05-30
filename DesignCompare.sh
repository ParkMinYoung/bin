
## create $1 and $2 merged bed 
mergeBed -i $1 > $1.merged
mergeBed -i $2 > $2.merged

## create overlap bed between $1 and $b
intersectBed -a $1.merged -b $2.merged > $1.merged.overlap.bed

## create complementary bed $1 and $b
subtractBed -a $1.merged -b $1.merged.overlap.bed > $1.merged.only
subtractBed -a $2.merged -b $1.merged.overlap.bed > $2.merged.only

## create covered %
coverageBed -a $2.merged -b $1.merged > $1.merged.cover
coverageBed -a $2 -b $1.merged > $1.nomerged.cover

## create interval length
for i in $1* $2* ; do echo -ne "$i\t" && GetBedLength.sh $i;done > $1.interval.length

DIR=design.compare.`date '+%Y%m%d%H%M'`
mkdir $DIR
mv $1.* $2.* $DIR
