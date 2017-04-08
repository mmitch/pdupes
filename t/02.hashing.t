#!perl
use Test::More tests => 3;
use warnings;
use strict;

use Test::TempDir::Tiny;

BEGIN { require_ok( '../pdupes' ) };

### initialize common test data (read only)

my $dir = tempdir();

my $file      = create_file($dir, 'fileA_short1', 'foo' );
my $samefile  = create_file($dir, 'fileB_short1', 'foo' );
my $otherfile = create_file($dir, 'fileC_short2', 'bar' );

my $longfile  = create_file($dir, 'fileD_long1', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'foo' );
my $longother = create_file($dir, 'fileE_long2', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'bar' );

### tests

subtest 'compute_short_hash()' => sub {

    my $hash = sub {
	my ($file) = (@_);
	return App::Pdupes::compute_short_hash( { NAME => $file, SIZE => -s $file, BLKSIZE => (stat $file)[11] } );
    };

    is  ( $hash->($samefile),  $hash->($file),      'equal files, equal hashes' );
    isnt( $hash->($otherfile), $hash->($file),      'different files, different hashes' );

    is  ( $hash->($longfile),  $hash->($longother), 'different long files give equal short hashes' );
    
};

subtest 'compute_long_hash()' => sub {

    my $hash = sub {
	my ($file) = (@_);
	return App::Pdupes::compute_long_hash( { NAME => $file, SIZE => -s $file, BLKSIZE => (stat $file)[11] } );
    };

    is  ( $hash->($samefile),  $hash->($file),      'equal files, equal hashes' );
    isnt( $hash->($otherfile), $hash->($file),      'different files, different hashes' );

    isnt( $hash->($longfile),  $hash->($longother), 'different long files give different long hashes' );
    
};

### helper functions

sub create_file
{
    my ($dir, $basename, $content) = (@_);

    my $name = "$dir/$basename";
    open OUT, '>', $name or die "can't open `$name': $!";
    print OUT $content;
    close OUT or die "can't close `$name': $!";
    
    return $name;
}
