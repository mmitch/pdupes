#!perl
use Test::More tests => 2;
use warnings;
use strict;

use File::Basename;
use Test::TempDir::Tiny;

BEGIN { require_ok( '../pdupes' ) };

### initialize common test data (read only)

my $dir = tempdir();

my $file        = create_file($dir, 'fileA_short1', 'foo' );
my $samefile    = create_file($dir, 'fileB_short1', 'foo' );
my $otherfile   = create_file($dir, 'fileC_short2', 'bar' );

my $longfile    = create_file($dir, 'fileD_long1', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'foo' );
my $longother   = create_file($dir, 'fileE_long2', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'bar' );

my $linkedfile1 = create_file($dir, 'fileG_linked', 'baz' );
my $linkedfile2 = "$dir/fileH_linked";
link $linkedfile1, $linkedfile2;

my $uniquefile  = create_file($dir, 'fileI_uniquesized', 'kilroy' );

### tests

subtest 'find_files()' => sub {

    my $allfiles = App::Pdupes::find_files( $dir );

    is( scalar keys %{$allfiles}, 1, 'all files on one device' );

    my $device = (keys %{$allfiles})[0];
    my $sizes = $allfiles->{$device};

    is( scalar keys %{$sizes}, 3, 'check size bins' );
    
    subtest 'size 3' => sub {
	my $files = $sizes->{3};
	is( scalar @{$files}, 5, 'file count' );

	my @filenames = sort map { basename($_->{NAME}) } @{$files};
	is_deeply( \@filenames,
		   [ 'fileA_short1', 'fileB_short1', 'fileC_short2', 'fileG_linked', 'fileH_linked' ],
		   'filenames' );
    };

    subtest 'size long' => sub {
	my $files = $sizes->{App::Pdupes::SHORT_HASH_LENGTH + 3};
	is( scalar @{$files}, 2, 'file count' );

	my @filenames = sort map { basename($_->{NAME}) } @{$files};
	is_deeply( \@filenames,
		   [ 'fileD_long1', 'fileE_long2' ],
		   'filenames' );
    };

    subtest 'size 6' => sub {
	my $files = $sizes->{6};
	is( scalar @{$files}, 1, 'file count' );

	my @filenames = sort map { basename($_->{NAME}) } @{$files};
	is_deeply( \@filenames,
		   [ 'fileI_uniquesized' ],
		   'filenames' );
    };

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
