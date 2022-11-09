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
use File::Path qw(make_path);
use Carp;

### Call the TestHelper and load it
use t::TestHelper;
my $h = TestHelper->new();

### Define the main globals
my ($t, $td, $croak_pattern);


$|=1;

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
# Make sure default input_root_dirs works properly.
################################################################################


$td = "Initial Load Test";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);


$td = "Make sure the input_root_dirs is defined";
ok(defined($t->input_root_dirs), $td);

$td = "Make sure input_root_dirs is an arrayref";
ok( (ref $t->input_root_dirs) eq "ARRAY", $td);


################################################################################
# Setup a new config string with only one input_root_dir
################################################################################


$h->load_sample_ini('dir_check_1.ini');


$td = "Reload modules with config that only has one input_root_dir";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);

$td = "Make sure the input_root_dirs is defined";
ok(defined($t->input_root_dirs), $td);

$td = "Make sure input_root_dirs is an arrayref";
ok( (ref $t->input_root_dirs) eq "ARRAY", $td);



################################################################################
# Verify the script reports that it stops if no input dirs are found
################################################################################

$h->load_sample_ini('no_available_inputs_1.ini');

$td = "Verify Croak if no available input_root_dir";

$croak_pattern = qr/No available input directories found./;

throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $croak_pattern, $td;

### Same thing with two missing input dirs

$h->load_sample_ini('no_available_inputs_2.ini');
throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $croak_pattern, $td;


################################################################################
# Croak if you have more than one valid input directory that exists
################################################################################


$td = "Made the necessary test input_dir.";
ok(make_path(sprintf("%s/data-input/input_root_b", $Bin)), $td);

$h->load_sample_ini('too_many_inputs_1.ini');

$td = "Verify Croak if more than one input directory exists.";

$croak_pattern = qr/Too many input directories found./;

throws_ok { $t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"); } $croak_pattern, $td;






################################################################################
### Clean up and finish up testing
################################################################################


#$h->cleanup();

done_testing();


