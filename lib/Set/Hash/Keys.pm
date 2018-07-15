package Set::Hash::Keys;

use List::Util 'reduce';

sub new {
    my $class = shift;
    my %data = @_;
    
    return bless \%data, $class
}

1;
