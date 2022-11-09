#!/usr/bin/perl 

################################################################################
# Description
################################################################################

=head1

Tests to make sure default values are loaded via the config properly. 

=cut
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
my $helper = TestHelper->new();

### Define the main globals
my ($t, $td, @initParams);


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

my @counter_roots_to_check = (
	sprintf('%s/data-output/output_root_a', $Bin),
	sprintf('%s/data-output/output_root_b', $Bin),
	sprintf('%s/data-output/output_video_root_a', $Bin),
	sprintf('%s/data-output/output_video_root_b', $Bin),
);

################################################################################
# Start testing
################################################################################


$td = "Initial Test";
#@ARGV = (); # override ARGV if you need.
@initParams = (ini_file_path => "ImportPhotosTest.ini");

### Load up the object
$t = new_ok($module_name, \@initParams, $td);

### Make sure that the framework attributes is defined
ok( defined($t->f), "Make sure ->f is defined.");

### Make sure the framework is of the correct type
isa_ok ($t->f, "AWSTools::Framework");


################################################################################
# Verify config values
################################################################################


$td = "Check that input_root_a is set properly.";
is( $t->f->config->{input_root_dir}->[0], sprintf('%s/data-input/input_root_a', $Bin), $td);

$td = "Check that input_root_b is set properly.";
is( $t->f->config->{input_root_dir}->[1], sprintf('%s/data-input/input_root_b', $Bin), $td);

$td = "Check that output_root_a is set properly.";
is( $t->f->config->{photo_output_root_dir}->[0], sprintf('%s/data-output/output_root_a', $Bin), $td);

$td = "Check that output_root_b is set properly.";
is( $t->f->config->{photo_output_root_dir}->[1], sprintf('%s/data-output/output_root_b', $Bin), $td);

$td = "Check that output_video_root_a is set properly.";
is( $t->f->config->{video_output_root_dir}->[0], sprintf('%s/data-output/output_video_root_a', $Bin), $td);

$td = "Check that output_video_root_a is set properly.";
is( $t->f->config->{video_output_root_dir}->[1], sprintf('%s/data-output/output_video_root_b', $Bin), $td);


### Check the counters
for my $counter_root (@counter_roots_to_check) {
	
	$td = sprintf("Verify moved counter for: %s is: 0", $counter_root);
	is($t->counters->{$counter_root}->{copied}, 0, $td);
	is($t->counters->{$counter_root}->{missing_datetime}, 0, $td);
	is($t->counters->{$counter_root}->{skipped_duplicates}, 0, $td);
	
}




################################################################################
### Clean up and finish up testing
################################################################################

$helper->cleanup();

done_testing();


