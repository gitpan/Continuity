#!/usr/bin/perl

package Guess;
use strict;
use base 'Continuity::Application';

sub setNumber {
  my $self = shift;
  $self->{number} = int(rand(100)) + 1;
}

sub getNum {
  my $self = shift;
  my $f = $self->disp(qq{
      Enter Guess: <input name="num">
      <input type=submit value="Guess"><br>
  });
  return $f->{'num'};
}

sub main {
  my $self = shift;
  $self->setNumber();
  my $guess;
  my $tries = 0;
  print "Hi! I'm thinking of a number from 1 to 100... can you guess it?<br>\n";
  do {
    $tries++;
    $guess = $self->getNum();
    print "It is smaller than $guess.<br>\n" if($guess > $self->{number});
    print "It is bigger than $guess.<br>\n" if($guess < $self->{number});
  } until ($guess == $self->{number});
  print "You got it! My number was in fact $self->{number}.<br>\n";
  print "It took you $tries tries.<br>\n";
  print '<a href="index.pl">Play Again</a>';
}

1;

