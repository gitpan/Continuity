#!/usr/bin/perl

use strict;
use Continuity;

Continuity->new( port => 8080 )->loop;

sub main {
  my ($r) = @_;
  $r->print(q|
    <html>
      <head>
        <script type="text/javascript" src="/jquery.js"></script>
        <script type="text/javascript">
          function listenLoop() {
            $.getScript('/', function(){ listenLoop(); });
          }
          $(function(){
            listenLoop();
          });
        </script>
      </head>
      <body>
        <h1>Hello</h1>
      </body>
    </html>
  |);
  while(1) {
    $r->next;
    print "Enter command: ";
    my $cmd = <>;
    $r->print($cmd);
  }
}

