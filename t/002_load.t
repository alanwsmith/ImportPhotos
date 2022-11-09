#!/usr/bin/perl 

################################################################################
# Description
################################################################################
# Test that all the proper objects and methods exist for the object and that
# now extra ones are thrown in.
################################################################################


################################################################################
# Make calls
################################################################################

use strict;
use warnings;
use Test::More;
use Test::Exception;
use Capture::Tiny qw(capture);
use FindBin qw($Bin);
use File::Path;
use Carp;

### Call the TestHelper and load it
use t::TestHelper;
my $h = TestHelper->new();

### Define the main globals
my $t;
my @initParams = (ini_file_path => "ImportPhotosTest.ini");


################################################################################
# Make sure the module can load and setup a global with its name
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

my $module_name = "ImportPhotos";


################################################################################
# Setup test specific globals
################################################################################


################################################################################
# Start testing
################################################################################


### Load up the object
$t = new_ok($module_name, \@initParams, "Initial load test.");


### Make sure it responds to "isa" okay.
isa_ok ($t, $module_name);



################################################################################
# Make sure you can't start without a config file
################################################################################



$h->remove_ini_file();


### Since the default will pick you your active config file, you
### Have to point this to an invalid location

dies_ok { $t = ImportPhotos->new(ini_file_path => "invalid_config_name.ini") } "Dies if no config file.";








################################################################################
### Clean up and finish up testing
################################################################################

$h->cleanup();

done_testing();


