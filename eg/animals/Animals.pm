
package Animals;
use base 'Continuity::Application';
use Data::Dumper;
use Carp;

sub init_once {
  my ($self) = @_;
  $self->{info} = "dog";
  $self->{msg} = '';
}

sub main {
  my ($self) = @_;

  $self->init_once();

  while(1) { 
    $self->{info} = $self->try($self->{info}); 
    last unless ($self->yes("play again?")); 
  }

  print "Bye!\n"; 
  print Dumper($self->{info});
}
 
sub try {
  my ($self, $this) = @_;
  if (ref $this) { 
    return $self->try($this->{$self->yes($this->{Question}) ? 'Yes' : 'No' }); 
  } 
  if ($self->yes("Is it a $this")) { 
    print "I got it!<br>"; 
    return $this;
  }; 
  print "no!?  What was it then? <br>"; 
  my $new = $self->getLine(); 
  print "And a question that distinguishes a $this from a $new would be? <br>"; 
  my $question = $self->getLine(); 
  my $yes = $self->yes("And for a $new, the answer would be..."); 
  my $val =  { 
             Question => $question, 
             Yes => $yes ? $new : $this, 
             No => $yes ? $this : $new, 
          }; 
  return $val;
} 
 
sub yes {
  my $self = shift;
  print "@_ (yes/no)?<br>"; 
  $self->getLine() =~ /^y/i; 
} 

sub getLine {
  my ($self) = @_;
  my $f = $self->disp(qq|
    <form method=POST>
      <input type=hidden name=pid value="$self->{continuity}->{newpid}">
      <input type=text name=ans>
    </form>
  |);
  print $f->{ans} . "<br>";
  return $f->{ans};
}

1;

