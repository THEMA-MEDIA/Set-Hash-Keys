package Set::Hash::Keys;

use List::Util 'reduce';

use overload(
    '+'   => sub { pop @_ ?        union($_[1],$_[0]) :        union($_[0],$_[1]) },
    '-'   => sub { pop @_ ?   difference($_[1],$_[0]) :   difference($_[0],$_[1]) },
    '*'   => sub { pop @_ ? intersection($_[1],$_[0]) : intersection($_[0],$_[1]) },
    '/'   => sub { pop @_ ?    exclusive($_[1],$_[0]) :    exclusive($_[0],$_[1]) },
    '%'   => sub {                                       symmetrical($_[0],$_[1]) },
);

use Exporter 'import';

@EXPORT = qw (
    &set_hash
);

@EXPORT_OK = qw (
    &union
    &intersection
    &difference
    &exclusive
    &symmetrical
);

%EXPORT_TAGS = (
    ':all' => \@EXPORT_OK,
);

sub set_hash {
    __PACKAGE__->new(@_)
}

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

sub exclusive {
    wantarray() ? difference( @_ ) : union( difference( @_ ) )
}

sub symmetrical {
    reduce { union ( difference( $a, $b ) ) } @_
}

1;
