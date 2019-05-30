 CEL=celfiles
 (echo "cel_files";ls *.CEL) > $CEL
 source $PWD/config
 DIR=./
 time apt-geno-qc --xml-file $DQC_XML --analysis-files-path $LIB_DIR --out-file $DIR/apt-geno-qc.txt --cel-files $CEL
 
