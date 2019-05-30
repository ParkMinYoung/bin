PID=$$
DIR=$KNIH/tmp.$PID
mkdir -p $DIR

cd $KNIH
find -mindepth 1 -maxdepth 1 -type f -name "*.CEL" > $DIR/A

cd /microarray/Genetitan/
find -mindepth 1 -maxdepth 1 -type f -name "*.CEL" > $DIR/B

(cd $DIR && ListStatus.sh A 1 B 1)

(cd $KNIH && cp -aruv `cat $DIR/A.missing` /microarray/Genetitan/)

rm -rf $DIR

