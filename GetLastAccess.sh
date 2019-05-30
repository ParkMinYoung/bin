for i in $@;
	do
	stat -c '%n %x' $i | sed 's/ \+/\t/'
done | perl -nle'print $1 if /(.+)\.\d+ \+/;'


