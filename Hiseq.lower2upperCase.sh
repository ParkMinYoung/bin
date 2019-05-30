for i in l???;do L=$(echo $i | tr [a-z] [A-Z]); mv $i $L; (cd $L; for j in c*.1;do C=$(echo $j | tr [a-z] [A-Z]); mv $j $C; done ) ;done
