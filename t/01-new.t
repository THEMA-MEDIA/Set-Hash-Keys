use Test::Most;

use Set::Hash::Keys;

subtest 'Constructing' => sub {
    plan tests => 1;
    
    my $set_0;
    lives_ok {
        $set_0 = Set::Hash::Keys->new();
    }
    "Can create an object from nothing";
    
};

done_testing();
