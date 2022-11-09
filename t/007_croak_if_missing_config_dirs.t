#!/usr/bin/perl 

################################################################################
=head1 Test Description

This test makes sure that the input and output directories are defined, 
are arrays and contain the proper data. 

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


my %croak_checks = (
	missing_input_1 => {
		pattern => qr/Missing input_root_dir/,
		ini_file => 'croak_check_1.ini'
	},

	missing_input_2 => {
		pattern => qr/Missing input_root_dir/,
		ini_file => 'croak_check_2.ini'
	},
	
	missing_output_1 => {
		pattern => qr/Missing photo_output_root_dir/,
		ini_file => 'croak_check_3.ini'
	},
	
	missing_output_2 => {
		pattern => qr/Missing photo_output_root_dir/,
		ini_file => 'croak_check_4.ini'
	},	
	
	
	missing_video_1 => {
		pattern => qr/Missing video_output_root_dir/,
		ini_file => 'croak_check_5.ini'
	},
	
	missing_video_2 => {
		pattern => qr/Missing video_output_root_dir/,
		ini_file => 'croak_check_6.ini'
	},
	
);




################################################################################
# Loop through the tests to verify they fail.
################################################################################


for my $croak_check (sort keys %croak_checks) {
	$td = "Checking: $croak_check - " . $croak_checks{$croak_check}{pattern};
	$h->load_sample_ini($croak_checks{$croak_check}{ini_file});
	throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $croak_checks{$croak_check}{pattern}, $td;
}






################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();


