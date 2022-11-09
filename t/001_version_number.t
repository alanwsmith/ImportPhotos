#!/usr/bin/perl 

################################################################################
# Description
################################################################################
# This is just a test to try to help you keep up with the vesrion number
################################################################################


################################################################################
# Make standard calls for testing
################################################################################

use strict;
use warnings;
use Test::More;
use Test::Exception;
use Capture::Tiny qw(capture);
use FindBin qw($Bin);
use File::Path;
use Carp;

################################################################################
# Call the module to test and set a global with its name
################################################################################

### Create the symbolic link to the .pm file if it doesn't exist
BEGIN {
	if(!-e "ImportPhotos.pm") {
		if(!symlink("ImportPhotos", "ImportPhotos.pm")) {
			die "Could not make symlink for ImportPhotos.pm";
		}	
	}
}

use ImportPhotos;

################################################################################

### Set the file which stores the version number
my $version_number_file = sprintf("%s/../VERSION_NUMBER", $Bin);

open (my $version_file_handle, '<', $version_number_file) || croak sprintf("Could not read %s.\n", $version_number_file);
my $version_number = do { local $/; <$version_file_handle> };
close $version_file_handle;

chomp($version_number);

$version_number = eval $version_number;

################################################################################

is(ImportPhotos->VERSION, $version_number, "Vesrion number is $version_number");

done_testing();

