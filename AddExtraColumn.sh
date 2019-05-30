#!/bin/sh



. ~/.bash_function
if [ $# -eq 4 ];then


perl -F'\t' -aslne'
BEGIN{
	$key=$key-1;
}

chomp@F;
if(@ARGV){
    @select_col = map { $_-1 } split ",", $columns;
    if($.==1){
        $head = join "\t", @F[@select_col];
		$space = "\t"x(@select_col-1);

    }else{
        $h{$F[$key]} = join "\t", @F[@select_col];
    }
}else{
    $col1 = shift @F;
    if(++$c==1){

        print join "\t", $col1, $head, @F;
    }elsif( $h{$col1} ){
        print join "\t", $col1, $h{$col1}, @F;
    }else{

        print join "\t", $col1, $space, @F;
	}

}

' -- -columns=$4 -key=$3 $2 $1 > $1.AddExtraColumn

else
	usage "Genotype $KORV1L key_col[1] \"3,5,6,7,8,10,14,15\" "
fi

