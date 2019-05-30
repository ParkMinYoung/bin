perl -snle'if(/^>(\w+)/){$id=$1}
else{   
        $seq=$_;
        while($l=substr($seq,0,$len,"")){
                $c++;
                $back=substr($l,$len-$overlap,$overlap);
                $seq=$back.$seq;
                #print "$l\t$back\t$seq";
                print ">$idSub$c\n$l";
                last if length($back) < $overlap;
        }
        $c="";
}' -- -len=1000 -overlap=700 $1
#}' -- -len=500 -overlap=300 $1
