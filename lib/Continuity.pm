
package Continuity;

use strict;

our $VERSION = '0.2';

=head1 NAME

Continuity - Continuation-based web-programming framework

=head1 SYNOPSIS

  #!/usr/bin/perl

  use strict;
  use Continuity;

  package Addnums;
  use base 'Continuity::Application';

  # --------------------------
  # This is the important bit.
  # --------------------------
  sub main {
    my $self = shift;
    my $a = $self->getNum('Enter first number: ');
    my $b = $self->getNum('Enter second number: ');
    $self->disp(" Total of $a + $b is: " . ($a + $b));
    # Run again!
    $self->main();
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

=head1 DESCRIPTION

This is an alternative to existing web-programming frameworks. The purpose of a
web-programming framework or toolkit is to speed and ease the development of
web-based applications. They tend to aid in management of state and of control
flow, often throwing in bonus hooks to common DB interfaces and templating
systems. Continuity is such a framework, meant to be minimalist in nature. What
sets this apart from the other frameworks is a single high-level programming
abstraction which allows you to pretend your program is being continuously
executing, rather than being re-started between each page display.

=head1 METHODS

=over

=item $c = new Continuity(appname => 'Myapp')

Creates a new Continuity object, ready to manage your application's instances.

=cut

use CGI;
use CGI::Session;
use CGI::Session::ID::MD5;
use Continuity::Template;
use Data::Dumper;

my %defaults = (
  print_header => 1,
  print_html_header => 0,
  print_form => 0,
);

sub new {
  my $class = shift;
  my (@parms) = @_;
  my $self = {
    %defaults,
    @parms
  };
  bless $self;
  return $self;
}

sub print_headers {
  my ($self) = @_;

  if($self->{print_header}) {
    # Print the header
    print $self->{s}->header();
    $self->{printed_header} = 1;
  }

  if($self->{print_html_header}) {
    print qq(
      <html>
        <head>
          <title>Continuity Application - $self->{appname}</title>
        </head>
        <html>
    );
  }

  if($self->{print_form}) {
    print qq(
      <form method=POST">
        <input type=hidden name=pid value="$self->{newpid}">
    );
  }
}

sub go {
  my ($self) = @_;

  # Set up the Query and Session
  $self->{q} = new CGI;
  $self->{s} = new CGI::Session(
    'serializer:Continuity', $self->{q}, {Directory=>"/tmp/"});

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

  $self->print_headers();

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

=back

=head1 BUGS/LIMITATIONS

This module uses the L<Contize> module to use fake continuations, and thus
comes with all the limitations therein.

=head1 SEE ALSO

L<Contize>, L<http://thelackthereof.org/wiki.pl/Continuity>

=head1 AUTHOR

  Brock Wilcox <awwaiid@thelackthereof.org>
  http://thelackthereof.org/

=head1 COPYRIGHT

  Copyright (c) 2004 Brock Wilcox <awwaiid@thelackthereof.org>. All rights
  reserved.  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself.

=cut

1;

