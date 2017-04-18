#!perl
use Test::More tests => 3;
use warnings;
use strict;

BEGIN { require_ok( '../pdupes' ) };

subtest 'min()' => sub {
    is( App::Pdupes::min(  2,  4 ),  2, 'first arg is smaller' );
    is( App::Pdupes::min(  4,  2 ),  2, 'second arg is smaller' );
    is( App::Pdupes::min(  1,  0 ),  0, 'zero' );
    is( App::Pdupes::min( -3, -2 ), -3, 'negative args' );
    is( App::Pdupes::min(  5,  5 ),  5, 'equal args' );

    is( App::Pdupes::min(  3,  2,  1,  0 ),  2, 'only first two parameters are compared' );
};

subtest 'remove_single_entries' => sub {

    my $test = sub {
	my ($got, $expected, $test_name) = (@_);
	App::Pdupes::remove_single_entries( $got );
	is_deeply( $got, $expected, $test_name );
    };
    
    $test->( {},
	     {},
	     'empty hash is unchanged');

    $test->( { A => [ 1, 2, 3 ], B => [ 2, 3 ] },
	     { A => [ 1, 2, 3 ], B => [ 2, 3 ] },
	     'filled hash is unchanged' );

    $test->( { A => [ 1, 2, 3 ], B => [ 3 ] },
	     { A => [ 1, 2, 3 ] },
	     'key with list of length 1 is removed' );

    $test->( { A => [ ], B => [ 3, 4, 5, 6 ] },
	     { B => [ 3, 4, 5, 6 ] },
	     'key with empty list is removed' );
};
