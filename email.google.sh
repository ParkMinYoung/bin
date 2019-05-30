#!/usr/bin/perl 

use Net::SMTP::SSL;

sub send_mail {
my $to = $_[0];
my $subject = $_[1];
my $body = $_[2];

my $from = 'p791227@gmail.com';
my $password = 'dnalinkmin';

my $smtp;

if (not $smtp = Net::SMTP::SSL->new('smtp.gmail.com',
                            Port => 465,
                            Debug => 1)) {
   die "Could not connect to server\n";
}

$smtp->auth($from, $password)
   || die "Authentication failed!\n";

$smtp->mail($from . "\n");
my @recepients = split(/,/, $to);
foreach my $recp (@recepients) {
    $smtp->to($recp . "\n");
}
$smtp->data();
$smtp->datasend("From: " . $from . "\n");
$smtp->datasend("To: " . $to . "\n");
$smtp->datasend("Subject: " . $subject . "\n");
$smtp->datasend("\n");
$smtp->datasend($body . "\n");
$smtp->dataend();
$smtp->quit;
}

# Send away!
&send_mail('minmin@dnalink.com', 'Server just blew up', 'Some more detail');

