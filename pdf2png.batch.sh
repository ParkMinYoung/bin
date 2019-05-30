for i in `find | grep pdf$`;do echo "`date` : pdf 2 png $i"; pdf2png.sh $i;done
