 for i in `find s_? -maxdepth 1 -type d`;do echo -n $i: && find $i -type f | wc -l;done
