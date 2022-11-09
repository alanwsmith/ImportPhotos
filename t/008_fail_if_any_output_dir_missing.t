#!/usr/bin/perl 

################################################################################
=head1 Test Description

This test runs a few scenerios with output directories that are missing to
confirm that the script won't work if that's the case. 

TODO:

	Set a check for an invalid video output directory. 
	

=cut
################################################################################





################################################################################
# Make calls
################################################################################

use Modern::Perl;
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
my ($t, $td, $pattern);


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


my @croak_checks = (
	{
		name => "One defined output dir that's missing.",
		pattern => qr{ERROR: Missing output directory - /invalid/junk/path/},
		ini_file => 'invalid_output_dir_1.ini',
	},
	
	{
		name => "One defined output dir that's missing.",
		pattern => qr{ERROR: Missing video output directory - /this/path/is/invalid},
		ini_file => 'invalid_output_dir_2.ini',
	},

);




################################################################################
# Loop through the tests to verify they fail.
################################################################################


for my $croak_check (@croak_checks) {
	$td = sprintf("Checking: %s", $croak_check->{name});
	$h->load_sample_ini($croak_check->{ini_file});
	throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $croak_check->{pattern}, $td;
}






################################################################################
### Clean up and finish up testing
################################################################################


ok($h->cleanup(), "Completed Test Cleanup");

done_testing();


