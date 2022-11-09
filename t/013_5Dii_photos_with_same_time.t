#!/usr/bin/perl 

################################################################################
=head1 Test Description

This is the test that makes sure that the images get moved to their proper
locations for the base level test. 


=cut
################################################################################



################################################################################
# Make calls
################################################################################

use Modern::Perl;
use Test::More;
use Test::Deep;
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

my @dest_photo_sub_paths = qw (
	
	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-01a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-01a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-02a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-02a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-03a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-03a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-04a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-04a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-05a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-05a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-06a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-06a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2052-07a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2052-07a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2057-01a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2057-01a.cr2

	data-output/output_root_a/2012/02-Feb/06/aws-20120206--2105-01a.cr2
	data-output/output_root_b/2012/02-Feb/06/aws-20120206--2105-01a.cr2
);


### Setup the hash for verification of the counters.
my %counter_check = (
	sprintf("%s/data-output/output_root_a", $Bin) => { 
		copied => 9,
		skipped_duplicates => 0,
		missing_datetime => 0,
	},
	sprintf("%s/data-output/output_root_b", $Bin) => { 
		copied => 9,
		skipped_duplicates => 0,
		missing_datetime => 0,
	},
	sprintf("%s/data-output/output_video_root_a", $Bin) => { 
		copied => 0,
		skipped_duplicates => 0,
		missing_datetime => 0,
	},
	sprintf("%s/data-output/output_video_root_b", $Bin) => { 
		copied => 0,
		skipped_duplicates => 0,
		missing_datetime => 0,
	},
);


################################################################################
# Start testing
################################################################################

### Load in the proper set of data samples
$h->load_data_samples("b");


$td = "Initial Load Test";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);

$td = "Run the move routine";
ok($t->copy_photos_to_destinations(), $td);


for my $dest_photo_sub_path (@dest_photo_sub_paths) {
	
	my $full_check_path = sprintf("%s/%s", $Bin, $dest_photo_sub_path);
	
	$td = "Make sure: $dest_photo_sub_path exists.";
	ok(-e $full_check_path, $td);
	
}


$td = "Verify the counters are correct.";
cmp_deeply($t->counters, \%counter_check, $td);


################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();
