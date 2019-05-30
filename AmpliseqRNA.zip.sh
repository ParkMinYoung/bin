(cd PDF && ls IonXpress_0*pdf | perl -nle'$c=$_;/(IonXpress_\d+)/;print "mv $c $1.summary.pdf"' | sh && rm -rf pdf)
(cd XLS && ls R* | perl -nle'$c=$_; /R.+(AmpliSeq.+)/; print "mv $c $1"' | sh)
(cd Fastq && ls IonXpress_0*fastq | perl -nle'$c=$_;/(IonXpress_\d+)/;print "mv $c $1.fastq"' | sh)

tar cvzf $(basename $PWD).tgz XLS/* PDF/* Fastq/*

