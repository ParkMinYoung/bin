perl -MMin -ane'if(/<Lane Index="\d">/){$id=$&}elsif(/<Tile>(\d+)/){$h{$1}{$id}++; $h{Total}{$id}++} }{ mmfss("out",%h) ' config.xml

