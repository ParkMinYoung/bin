#!/bin/sh

if [ -f "$1" ] & [ $# -eq 2 ] ;then

	INPUT=$1
	OUTPUT=$2

	CIRCOS_CONF=~/src/short_read_assembly/bin/circos_conf

	perl -nle'print "ln -s $_ heatmap.",$c++,".txt" ' $INPUT | sh

	ls heatmap.*.txt | perl -nle'print "<<include heatmap.conf>>"' > $CIRCOS_CONF/human.heatmap.conf/plot.conf
	circos -conf $CIRCOS_CONF/human.heatmap.conf/circos.conf -outputfile $OUTPUT.heatmap
	
	ls heatmap.*.txt | perl -nle'print "<<include hist.conf>>"' > $CIRCOS_CONF/human.hist.conf/plot.conf
	circos -conf $CIRCOS_CONF/human.hist.conf/circos.conf -outputfile $OUTPUT.hist
	

	# -param chromosomes_display_default=no -param chromosomes=hs1
	rm -rf heatmap.*.txt

else

	usage "File_List OUTPUT_NAME"
fi

