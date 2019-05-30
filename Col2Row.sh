
#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

paste <(cat -n $1 | awk '{print $1}') $1 > $1.num
MatrixTransform.NotReorder.sh $1.num
perl -F'\t' -anle'($col,@list) = @F; map { print join "\t", $col, $_ } @list if $.>1'  $1.num.Transform.NotReorder > $1.col2row
rm -rf $1.num $1.num.Transform.NotReorder

else
	usage "Matrix"
fi


