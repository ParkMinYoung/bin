
#for i in `find $RMD | grep SampleStatusByScanner`; do rm -rf $i && dirname $i ; done | sort | uniq | xargs -i ln -s $PWD/SampleStatusByScanner* {}
for i in $(find $RMD | grep $1)
	do 
	rm -rf $i && dirname $i 
done | sort | uniq | xargs -i ln -s $PWD/$1* {}
