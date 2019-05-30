perl -nle's/[\000-\011\013\014\016-\037]//g; if(/partial-dat-header.+(\d\d\/\d\d\/\d\d)/){print "$ARGV\t$1"}elsif(/DatHeader.+(\d\d\/\d\d\/\d\d)/){print "$ARGV\t$1"}' $1 

# ls *.CEL | xargs -n 1 -P 20 wrapper.sh ./GetDataFromCEL.sh > min.date
