mkdir -p delete.folder/L00{1..8}
perl -le'map { /(L\d+)\/C(\d+)/; `mv $_ delete.folder/$_` if $2 <79 } @ARGV' L00{1..3}/*
