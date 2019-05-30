#!/bin/bash


. ~/.bash_function

if [ -f "$1" ];then 


## set : default value
default_group=A
default_max=1000

## naming
LIST_FILE=$1
GROUP_VALUE=${2:-$default_group}
MAX=${3:-$default_max}


cat $LIST_FILE | \
perl -MList::Util=shuffle -MMin -MList::MoreUtils=natatime -sne'
chomp;
push @list, $_;

}{
 @list = shuffle(@list);
 $iterator = natatime $max, @list;

 while (my @set = $iterator->()) {
    $c++;
    map{ $h{$_}{$group}=$c } @set;
   }
  
  mmfss($group, %h);
' -- -max=$MAX -group=$GROUP_VALUE


else
		usage "list_file group[A] max_value[1000]"

fi


