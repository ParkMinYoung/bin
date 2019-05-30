
GetWillBeUpdatedMarkerSortedGenoInBim.sh $1.bim > SortedGenoMarker
plink2 --bfile $1 --update-map SortedGenoMarker --update-name  --make-bed --out $1.SortedGeno --allow-no-sex --threads 20

