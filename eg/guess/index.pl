#!/usr/bin/perl

use strict;
use Continuity;
use Guess;

my $c = new Continuity(
  appname => 'Guess',
  print_html_header => 1,
  print_form => 1,
);

$c->go();

