T=$1
shift
zcat $@ | gzip - > $T.gz
