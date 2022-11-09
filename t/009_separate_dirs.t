#!/usr/bin/perl 

################################################################################
=head1 Test Description

This test makes sure that the input directory is not inside the output
directory and vice versa. 

TODO

	Setup testing to make sure movie directories aren't nested in input
	directories in the same way that photo directories aren't. 
	
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
use File::Path qw(make_path);
use Carp;

### Call the TestHelper and load it
use t::TestHelper;
my $h = TestHelper->new();

### Define the main globals
my ($t, $td);


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


my @invalid_dir_configs = (
	
	{
		name => "Invalid 'input_root_dir' inside 'photo_output_root_dir'",
		pattern => qr{ERROR: Invalid input_root_dir defined \([^\)]+\). Can't be inside an 'photo_output_root_dir'},
		ini_file => "bad_nesting_01.ini",
	},

	{
		name => "Invalid 'input_root_dir' inside 'photo_output_root_dir' with multiple inputs",
		pattern => qr{ERROR: Invalid input_root_dir defined \([^\)]+\). Can't be inside an 'photo_output_root_dir'},
		ini_file => "bad_nesting_02.ini",
	},	
		
	{
		name => "Invalid 'input_root_dir' inside 'photo_output_root_dir' with multiple outputs",
		pattern => qr{ERROR: Invalid input_root_dir defined \([^\)]+\). Can't be inside an 'photo_output_root_dir'},
		ini_file => "bad_nesting_03.ini",
	},
	
	{
		name => "Invalid 'photo_output_root_dir' inside 'input_root_dir'",
		pattern => qr{ERROR: Invalid photo_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_04.ini",
	},

	{
		name => "Invalid 'photo_output_root_dir' inside 'input_root_dir' with multiple outputs",
		pattern => qr{ERROR: Invalid photo_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_05.ini",
	},

	{
		name => "Invalid 'photo_output_root_dir' inside 'input_root_dir' with multiple inputs",
		pattern => qr{ERROR: Invalid photo_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_06.ini",
	},
	
	{
		name => "Invalid 'video_output_root_dir' inside 'input_root_dir'",
		pattern => qr{ERROR: Invalid video_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_07.ini",
	},

	{
		name => "Invalid 'video_output_root_dir' inside 'input_root_dir' with multiple outputs",
		pattern => qr{ERROR: Invalid video_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_08.ini",
	},

	{
		name => "Invalid 'video_output_root_dir' inside 'input_root_dir' with multiple inputs",
		pattern => qr{ERROR: Invalid video_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_09.ini",
	},
	
	{
		name => "Invalid 'photo_output_root_dir' duplicate of 'input_root_dir'",
		pattern => qr{ERROR: Invalid photo_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_10.ini",
	},
	
	{
		name => "Invalid 'video_output_root_dir' duplicate of 'input_root_dir'",
		pattern => qr{ERROR: Invalid video_output_root_dir defined \([^\)]+\). Can't be inside an 'input_root_dir'},
		ini_file => "bad_nesting_11.ini",
	},
	
);




################################################################################
# Start testing
################################################################################

### Make the target invalid input dir so it doesn't croak because it's missing. 

ok(make_path(sprintf('%s/data-output/output_root_a/invalid_intput_dir', $Bin)), "Make necessary input target direcotry");

for my $invalid_config (@invalid_dir_configs) {
	$td = $invalid_config->{ini_file} . " - " . $invalid_config->{name};
	$h->load_sample_ini($invalid_config->{ini_file});
	throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $invalid_config->{pattern}, $td;
}




################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();


