package Set::Hash::Keys;

use List::Util 'reduce';

sub new {
    my $class = shift;
    my %data = @_;
    
    return bless \%data, $class
}

sub difference {
    return unless defined $_[0];
    
    if ( wantarray() ) {
        my $sets_ref = [];
        for my $i ( 0 .. $#_ ) {
            my @other = @_; # make a clone, since splice mutates it
            my $set_i = splice( @other, $i, 1 );
            my $set_d = difference( $set_i, @other );   
            push @$sets_ref, $set_d;
        }
        return @$sets_ref
    }
    
    my $hash_ref = reduce {
        +{
            map {
                $_, $a->{$_}
            } grep {
                !exists $b->{$_}
            } keys %$a
        }
    } @_;
    
    __PACKAGE__->new( %$hash_ref )
}

1;
