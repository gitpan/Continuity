
package Continuity::Application;

=head1 NAME

Continuity::Application - Base class for Continuity applications

=cut

use strict;
use warnings qw( all );
use base 'Continuity::Module';

sub render
{
  my $self = shift;
  my $c = $self->{continuity};
  my $out = $self->{content};
  $self->{content} = '';
  $out =~ s/(<a\s.*?href=("|'))(.*?\?.*?)(\2.*?>)/$1$3&pid=$c->{newpid}$4/gm;
  $out =~ s/(<a\s.*?href=("|'))([^\?]*?)(\2.*?>)/$1$3?pid=$c->{newpid}$4/gm;
  print $out;
  $c->{s}->flush();
}

sub addContent
{
  my ($self, $content) = @_;
  $self->{content} .= $content;
  return $content;
}

sub setContent
{
  my ($self, $content) = @_;
  $self->{content} = $content;
  return $content;
}


1;

