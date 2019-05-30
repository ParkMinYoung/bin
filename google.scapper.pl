#!/usr/bin/perl

use Google::Search;
use LWP::Simple;
use File::Basename;
use DBI;


$query= join " ", @ARGV;    
print $query,"\n";

$search = Google::Search->Web( query => $query );
#$search = Google::Search->Web( query => "site:www.ebi.ac.uk filetype:pdf sequence" );


$word = $ARGV[-1];
mkdir($word) if !-d $word;

 	
$dbh = DBI->connect(
    "dbi:SQLite:dbname=GoogleSearch.db",
    "",
    "",
    { RaiseError => 1}
) or die $DBI::errstr;

$dbh->do("DROP TABLE IF EXISTS $word");
$dbh->do("CREATE TABLE $word (id INTEGER PRIMARY KEY AUTOINCREMENT,regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,URL TEX,NAME1 TEX, NAME2 TEX);");

while ( $result = $search->next ){ 
#print $result->uri, "\n"; 
	$url = $result->uri;
	($file1) = fileparse($url);

	$file2=$file1;
	if( -e "$word/$file1"){
		$range =1000;
		$num = int(rand($range));
		$file2=~s/\.pdf$/.$num.pdf/;
	}

	$dbh->do("insert into $word(URL,NAME1,NAME2) values('$url', '$file1', '$file2');");
	#print "insert into $word(URL,NAME1,NAME2) values('$url', '$file', '$file')\n";
	#print join "\t", $url, $file, "\n";
	getstore($url, "$word/$file2");

}
#while ( $result = $search->next ) { print join "\t", $result->rank, $result->uri, "\n"; }


$dbh->disconnect();

