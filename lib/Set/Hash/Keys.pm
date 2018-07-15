package Set::Hash::Keys;

sub new {
    my $class = shift;
    my %data = @_;
    
    return bless \%data, $class
}

1;
