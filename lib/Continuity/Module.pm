
package Continuity::Module;

=head1 NAME

Continuity::Module - Base class for modules in a Continuity application

=cut

use strict;
use Contize;

sub new
{
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { @_ };
  bless $self, $class;
  $self = new Contize($self);
  $self->nocache('addContent', 'render');
  return $self;
}

sub display {
  my ($self, $content) = @_;
  $self->{app}->addContent($content);
  $self->{app}->render;
  $self->suspend();
}

sub disp {
  my ($self, $content) = @_;
  $self->display($content);
  my $form = $self->{app}->{q}->Vars();
  return $form;
}

sub dispTemplate {
  my ($self, $file, %params) = @_;
  my $tpl = new Continuity::Template($file);
  foreach my $name (keys %params) {
    $tpl->set($name => $params{$name});
  }
  my $content = $tpl->render();
  # This copies the result instead of returning the same ref
  my $f = { %{$self->disp($content)} };
  return $f;
}

sub cleanup {
  my $self = shift;
  my $c = $self->{app}->{continuity};
  $c->save();
}

1;

