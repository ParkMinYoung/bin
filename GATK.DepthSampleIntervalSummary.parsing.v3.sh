#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

perl -F'\t' -anle'
BEGIN{
    $start_col_num  = 1; # interval col position
    $start_col      = 4; # first mean depth postion
    $repeat_col_num = 26; # repeat interval
}
if($.==1){

    $operation = (@F-$start_col_num)/$repeat_col_num;

    push @col, $start_col_num;
    map { push @col, ($_-1)*$repeat_col_num+ $start_col } 1 .. $operation;
    map { $_-- } @col;

    @header = @F[@col]; 
    map { s/_mean_cvg// } @header;
    
    print join "\t", @header;

}else{
    print join "\t", @F[@col];
}' $1 > $1.DepthCov


else
	usage "XXX.sample_interval_summary"
fi

