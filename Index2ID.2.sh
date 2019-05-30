find Bam/ | grep process | xargs rm -rf


cd PDF
rm -rf pdf
ls IonXpress_*pdf | perl -nle'$c=$_;  s/(IonXpress_\d{3})(.+)(.pdf)/\1\3/;  print "mv $c $_"' | sh
cd ..


cd Fastq 
ls | perl -nle'$c=$_; s/(IonXpress_\d{3})(.+)(.fastq)/\1\3/;  print "mv $c $_"' | sh
ls *fastq | xargs -n 1 -P10 gzip
cd ..

