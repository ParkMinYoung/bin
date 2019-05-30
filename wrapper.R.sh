
Rscript=$1
shift

#echo "--args $@" $Rscript
R CMD BATCH --no-save --no-restore "--args $@" $Rscript
