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





################################################################################
# Make sure default output_root_dirs works properly.
################################################################################


$td = "Initial Load Test";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);


$td = "Make sure the photo_output_root_dirs is defined";
ok(defined($t->photo_output_root_dirs), $td);

$td = "Make sure photo_output_root_dirs is an arrayref";
ok( (ref $t->photo_output_root_dirs) eq "ARRAY", $td);


$td = "Make sure video_output_root_dirs is defined";
ok(defined($t->video_output_root_dirs), $td);

$td = "Make sure video_output_root_dirs is an arrayref";
ok( (ref $t->video_output_root_dirs) eq "ARRAY", $td);




################################################################################
# Setup a new config string with only one output_root_dir
################################################################################


$h->load_sample_ini('dir_check_2.ini');

$td = "Reload modules with config that only has one output_root_dir per type";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);

$td = "Make sure the photo_output_root_dirs is defined";
ok(defined($t->photo_output_root_dirs), $td);

$td = "Make sure photo_output_root_dirs is an arrayref";
ok( (ref $t->photo_output_root_dirs) eq "ARRAY", $td);


$td = "Make sure video_output_root_dirs is defined";
ok(defined($t->video_output_root_dirs), $td);

$td = "Make sure video_output_root_dirs is an arrayref";
ok( (ref $t->video_output_root_dirs) eq "ARRAY", $td);



################################################################################
# Setup a new config string with two output_root_dir items
################################################################################


$h->load_sample_ini('dir_check_1.ini');


$td = "Reload modules with config that only has two output_root_dir keys";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);

$td = "Make sure the photo_output_root_dirs is defined";
ok(defined($t->photo_output_root_dirs), $td);

$td = "Make sure photo_output_root_dirs is an arrayref";
ok( (ref $t->photo_output_root_dirs) eq "ARRAY", $td);


$td = "Make sure video_output_root_dirs is defined";
ok(defined($t->video_output_root_dirs), $td);

$td = "Make sure video_output_root_dirs is an arrayref";
ok( (ref $t->video_output_root_dirs) eq "ARRAY", $td);





################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();

