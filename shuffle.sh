ls $@ | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);'

