# use HTML::HTMLDoc;
#  
# my $htmldoc = new HTML::HTMLDoc();
#  
# $htmldoc->set_html_content(qq~<html><body>A PDF file</body></html>~);
# # $htmldoc->set_input_file($filename); # alternative to use a present file from your fs
#  
# my $pdf = $htmldoc->generate_pdf();
#  
# print $pdf->to_string();
# $pdf->to_file('foo.pdf');


htmldoc --webpage --browserwidth 1200 --fontsize 8 -f $1.pdf $1

