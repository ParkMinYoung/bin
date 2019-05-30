#!/usr/bin/perl

use Net::SMTP::SSL;
use MIME::Base64;
use File::Spec;
use LWP::MediaTypes;
use Pod::Usage;
use Getopt::Long;

#my %options;
#GetOptions(\%options, "--help", "--from=s", "--password=s", "--to=s", "--subject=s", "--contents=s@", "--attach=s");

sub send_mail_with_attachments {
 my $to = shift(@_);
 my $subject = shift(@_);
 my $body = shift(@_);
 my @attachments = @_;

 my $from = 'p791227@gmail.com';
 my $password = 'dnalinkmin';

 my $smtp;

 if (not $smtp = Net::SMTP::SSL->new('smtp.gmail.com',
                              Port => 465,
                              Debug => 1)) {
     die "Could not connect to server\n";
 }

 # Authenticate
 $smtp->auth($from, $password)
     || die "Authentication failed!\n";

 # Create arbitrary boundary text used to seperate
 # different parts of the message
 my ($bi, $bn, @bchrs);
 my $boundry = "";
 foreach $bn (48..57,65..90,97..122) {
     $bchrs[$bi++] = chr($bn);
 }
 foreach $bn (0..20) {
     $boundry .= $bchrs[rand($bi)];
 }

 # Send the header
 $smtp->mail($from . "\n");
 my @recepients = split(/,/, $to);
 foreach my $recp (@recepients) {
     $smtp->to($recp . "\n");
 }
 $smtp->data();
 $smtp->datasend("From: " . $from . "\n");
 $smtp->datasend("To: " . $to . "\n");
 $smtp->datasend("Subject: " . $subject . "\n");
 $smtp->datasend("MIME-Version: 1.0\n");
 $smtp->datasend("Content-Type: multipart/mixed; BOUNDARY=\"$boundry\"\n");

 # Send the body
 $smtp->datasend("\n--$boundry\n");
 $smtp->datasend("Content-Type: text/plain\n");
 $smtp->datasend($body . "\n\n");

 # Send attachments
 foreach my $file (@attachments) {
     unless (-f $file) {
         die "Unable to find attachment file $file\n";
         next;
     }
     my($bytesread, $buffer, $data, $total);
     open(FH, "$file") || die "Failed to open $file\n";
     binmode(FH);
     while (($bytesread = sysread(FH, $buffer, 1024)) == 1024) {
         $total += $bytesread;
         $data .= $buffer;
     }
     if ($bytesread) {
         $data .= $buffer;
         $total += $bytesread;
     }
     close FH;

     # Get the file name without its directory
     my ($volume, $dir, $fileName) = File::Spec->splitpath($file);
  
     # Try and guess the MIME type from the file extension so
     # that the email client doesn't have to
     my $contentType = guess_media_type($file);
  
     if ($data) {
         $smtp->datasend("--$boundry\n");
         $smtp->datasend("Content-Type: $contentType; name=\"$fileName\"\n");
         $smtp->datasend("Content-Transfer-Encoding: base64\n");
         $smtp->datasend("Content-Disposition: attachment; =filename=\"$fileName\"\n\n");
         $smtp->datasend(encode_base64($data));
         $smtp->datasend("--$boundry\n");
     }
 }

 # Quit
 $smtp->datasend("\n--$boundry--\n"); # send boundary end message
 $smtp->datasend("\n");
 $smtp->dataend();
 $smtp->quit;
}

# Send away!
# &send_mail_with_attachments('minmin@dnalink.com', 'Server attach test', 'Some more detail', 'C:\logs\server.log', 'C:\logs\server-screenshot.jpg');
&send_mail_with_attachments(@ARGV);

