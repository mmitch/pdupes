#!perl
use Test::More tests => 4;
use warnings;
use strict;

use File::Basename;
use Test::TempDir::Tiny;

BEGIN { require_ok( '../pdupes' ) };

### check for symlinks

my $symlinks_available = eval { symlink("",""); 1 };

### initialize test data (read/write)

my $dir = tempdir();
my $subdir = "$dir/subdir";

mkdir "$dir/subdir";
my $file        = create_file($dir   , 'fileA_short1', 'foo' );
my $samefile    = create_file($subdir, 'fileB_short1', 'foo' );
my $otherfile   = create_file($dir,    'fileC_short2', 'bar' );

my $longfile    = create_file($subdir, 'fileD_long1', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'foo' );
my $longother   = create_file($dir,    'fileE_long2', ':' x App::Pdupes::SHORT_HASH_LENGTH . 'bar' );

my $linkedfile1 = create_file($dir,    'fileG_linked', 'baz' );
my $linkedfile2 = "$subdir/fileH_linked";
link $linkedfile1, $linkedfile2;

my $uniquefile  = create_file($subdir, 'fileI_uniquesized', 'kilroy' );

my $symlink = "$subdir/file_J_symlink";
symlink $uniquefile, $symlink if $symlinks_available;

### run pdupes

App::Pdupes->run( $dir );

### check results

subtest 'check file contents' => sub {

    is( read_file($file),        'foo', '$file content' );
    is( read_file($samefile),    'foo', '$samefile content' );
    is( read_file($otherfile),   'bar', '$otherfile content' );

    is( read_file($longfile),    ':' x App::Pdupes::SHORT_HASH_LENGTH . 'foo', '$longfile content' );
    is( read_file($longother),   ':' x App::Pdupes::SHORT_HASH_LENGTH . 'bar', '$longother content' );

    is( read_file($linkedfile1), 'baz', '$linkedfile1 content' );
    is( read_file($linkedfile2), 'baz', '$linkedfile2 content' );

    is( read_file($uniquefile),  'kilroy', '$uniquefile content' );
    
};

subtest 'check hardlinks' => sub {

    is( get_inode($linkedfile2), get_inode($linkedfile1), 'linked files still linked' );
    is( get_inode($samefile),    get_inode($file),        'equal files got hardlinked' );
    
};

subtest 'check symlink' => sub {

    plan skip_all => 'symlinks not available' unless $symlinks_available;

    ok( -l $symlink,                   'symlink still there' );
    is( read_file($symlink), 'kilroy', 'symlinked file content' );
    
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

sub read_file
{
    my ($name) = (@_);

    open IN, '<', $name or die "can't open `$name': $!";
    local $/ = undef;
    my $content = <IN>;
    close IN or die "can't close `$name': $!";
    
    return $content;
}

sub get_inode
{
    my ($name) = (@_);

    return (stat $name)[1];
}
