 find $PWD/ -maxdepth 1 -type d  | grep "Basecall_Stats" | \
 perl -nle'
 $c=$_;
 s/\//./g; 
 /(.+)\.Data.+(Fas.+)\.Base/i; 
 $Target="~/workspace.min/DNALink.Hiseq/$1.$2";
 $Target=~s/\.hiseq\.//;
`cp -ur $c $Target;chmod +rx $Target`' 

