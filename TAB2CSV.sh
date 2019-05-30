perl -lpe 's/"/""/g; s/^|$/"/g; s/\t/","/g' $1 > $1.csv
