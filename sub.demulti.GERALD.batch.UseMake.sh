
for i in `find 00{2,3,4,5,6,7,9} 010 -maxdepth 1 -type d | grep GERALD`
    do cwd=$PWD
       NAME=GER.${i:0:3}
       echo $i && cd $i
       make recursive -j 3 >& $NAME.log
       cd $cwd
done

