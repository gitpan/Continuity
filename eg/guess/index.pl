#!/usr/bin/perl

use strict;
use Continuity;
use Guess;

my $c = new Continuity(
  appname => 'Guess'
);

$c->go();

