#!/usr/bin/perl

use strict;
use Continuity;
use Animals;

my $c = new Continuity(
  appname => 'Animals'
);

$c->go();

