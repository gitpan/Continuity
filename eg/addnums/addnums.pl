#!/usr/bin/perl

use strict;
use Continuity;

package Addnums;
use base 'Continuity::Application';

sub main {
  my $self = shift;
  my $a = $self->getNum('Enter first number: ');
  my $b = $self->getNum('Enter second number: ');
  $self->disp("
    Total of $a + $b is: " . ($a + $b) . ".
    So there.
    <a href='#'>Reload</a>
    ");
}
  
sub getNum {
  my ($self, $msg) = @_;
  my $f = $self->disp(qq{
      $msg <input name="num">
      <input type=submit value="Enter"><br>
  });
  return $f->{'num'};
}

package main;

my $c = new Continuity(
  appname => 'Addnums',
  print_html_header => 1,
  print_form => 1,
);

$c->go();

