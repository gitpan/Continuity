
package Continuity;

use strict;

our $VERSION = '0.1';

=head1 NAME

Continuity - Continuation-based web-programming framework

=cut

use CGI;
use CGI::Session;
use CGI::Session::ID::MD5;
use Continuity::Template;
use Data::Dumper;

sub new {
  my $class = shift;
  my (@parms) = @_;
  my $self = { @parms };
  bless $self;
  return $self;
}

sub go {
  my ($self) = @_;

  # Set up the Query and Session
  $self->{q} = new CGI;
  $self->{s} = new CGI::Session(
    'serializer:Continuity', $self->{q}, {Directory=>"/tmp/"});

  # Print the header
  print $self->{s}->header();
  $self->{printed_header} = 1;


  # Grab the current PageID from the query, and set up the next PageID
  $self->{pid} = $self->{q}->param('pid');
  $self->{newpid} = CGI::Session::ID::MD5::generate_id();

  if($self->{pid}) {
    # We were given a PID, lets pick up there
    $self->{cur} = $self->{s}->param($self->{pid});
    if($self->{cur}) {
      $self->{app} = $self->{cur}->{'page'};
    } else {
      # Couldn't continue, so start over
      $self->{app} = $self->{appname}->new();
    }
  } else {
    # No PID, start from the beginning
    $self->{pid} = '0';
    $self->{app} = $self->{appname}->new();
  }

  # I would like to eliminate this bit... but I don't know how
  # It fixes CGI::Session's save of the panel object
  my $VAR1;
  eval(Dumper($self->{app}));
  $self->{app} = $VAR1;

  $self->{app}->{continuity} = $self;
  $self->{app}->{q} = $self->{q};
  $self->{app}->{app} = $self->{app};
  $self->{app}->resume();

  # And last but not least, start the application!
  $self->{app}->main();

  # Then we NUKE IT ALL!!
  $self->{s}->delete();
}

sub save {
  my $self = shift;
  if ($self->{s}) {
    delete $self->{app}->{q};
    delete $self->{app}->{app};
    delete $self->{app}->{continuity};
    $self->{s}->param($self->{newpid}, {
      'page' => $self->{app},
      'timestamp' => time
    });
    $self->{s}->flush();
  }
}

1;

