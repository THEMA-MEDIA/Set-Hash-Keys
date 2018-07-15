package Set::Hash::Keys;

use List::Util 'reduce';

sub new {
    my $class = shift;
    my %data = @_;
    
    return bless \%data, $class
}

sub union {
    return unless defined $_[0];

    my $hash_ref = reduce {
        +{ %$a, %$b }
    } @_;
    
    __PACKAGE__->new( %$hash_ref );
}

sub intersection {
    return unless defined $_[0];

    my $hash_ref = reduce {
        +{
            map {
                $_, $b->{$_}
            } grep {
                exists $b->{$_}
            } keys %$a
        }
    } @_;
    
    __PACKAGE__->new( %$hash_ref );
}

1;
