#!/usr/bin/env perl

# http://digitalcrunch.com/perl/test-list-of-urls-for-fastest-response/

use strict;
use warnings;
use Net::Ping;
use Time::HiRes;

# takes a list of urls, pings them, returns a sorted list
# originally was written when choosing cpan modules
# $order is supposed to match the list provided by perl 5.8.8
# $order isn't useful for testing other types of URLS
# but the rest of the script should be

# I've already commented out ones that are frequently down
my %sortedURLS;
my %URLS;

readURLs();
checkURLS();
sortURLS();

sub readURLs {
  my $c=0;
  while (<>) {
     $URLS{$c++} = $_;
  }
}

sub checkURLS {
  print "TESTING URLS FROM LIST, PLEASE WAIT...\n\n";
  my $x = 0;
  my $p = Net::Ping->new('icmp');
  $p->hires();
  foreach my $order ( keys %URLS ){
    my $cpan      = $order;
    my $location  = $URLS{$order};
    my $host      = trim($location);
    my ($success, $timed, $ip) = $p->ping($host);

    if ($success) {
      $sortedURLS{$timed} = "$order $host";
      print "success: $host\n";
    } else {
      print "failed : $host\n";
    }
  }
}

sub sortURLS {
  print "\nFINAL RESULTS:\n";
  foreach my $timed ( sort (keys %sortedURLS) ) {
    my ($order, $host) = split(/ /, $sortedURLS{$timed});
    printf ("$order\t%.2f ms\t $host\n", $timed * 1000);
  }
}

#function that trims a domain
sub trim {
  $_ = my $input = shift;
  $_ =~ s/^\s+//;     # strip spaces at start of string
  $_ =~ s/\s+$//;     # strip spaces at end of string
  $_ =~ s|^http://||; # strip http:// at begining
  $_ =~ s|^ftp://||;  # strip ftp:// at beginning
  $_ =~ s|/.*$||;     # strip everything after the first /
  my $trimmed = $_;
  return $trimmed;
}
