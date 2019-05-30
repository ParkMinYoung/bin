
#!/bin/sh

source ~/.bash_function

if [ $# -ge 1 ];then

	for i in $@
	    do if [ -f "$i" ];then
		   echo "File : $i exist!"
		else
		   echo "Exit : $i check!"
		   ERR=1
		fi
	done
        
	if [ $ERR ];then
		usage XXX.sam [ YYY.sam ZZZ.sam .... ]
	fi

	
	perl -MMin -ne'@F=split "\t",$_,4;
	if(/SN:(.+)\tLN:(\d+)/){
		$h{$1}{Length}=$2;
	}elsif(/^(HW|ILL)/){
		$h{$F[2]}{$ARGV}++;
		$h{Total}{$ARGV}++;
		$h{Align}{$ARGV}++ if $F[2] ne "*";
	} }{ mmfss("Align.read.count",%h)' $@

else
	usage XXX.sam [ YYY.sam ZZZ.sam .... ]
fi
