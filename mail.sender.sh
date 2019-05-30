#!/usr/bin/perl

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
 

#print $ARGV[0];
#print $ARGV[1];

($title, $body) = @ARGV;

$body=$ARGV[1];
$body =~ s/\\n/\n/g;
#print "$body\n";
#exit;


$email = Email::Simple->create(  

				header => [    
					To   => '"Park MinYoung" <p791227+bot@gmail.com>', 
					From => '"Park MinYoung" <analysis_bot@dnalink.com>',    
					Subject => $title 
					],  

				body => $body."\nBest Regard,\nanalysis-bot\n"
				);

sendmail($email);

# https://metacpan.org/pod/Email::Sender::Manual::QuickStart

# ~/bin/mail.sender.sh "The Run is Completed successfully" "Dear, Minyoung\n\nThe Run is completed successfully.\nDon't worry about it\n"
