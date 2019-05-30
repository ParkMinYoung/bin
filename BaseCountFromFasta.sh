perl -MMin -sne'
if(/^>(\w+)/){
	$id=$1
}else{
	chomp;
	map {
			$h{$id}{uc(chr($_))}++;
			$h{$id}{Total}++;
			$h{Total}{uc(chr($_))}++;
			$h{Total}{Total}++;
	} unpack "C*", $_
} 
}{ 
		mmfns("$file.BaseCount",%h)' -- -file=$1 $1
