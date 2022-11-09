#!/usr/bin/perl 

################################################################################
=head1 Test Description

Checks to make sure the list of files to move is accurate. 



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

### Array to hold file paths
my @file_list_sub_paths;

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
# Start Testing
################################################################################


################################################################################
# Run test with default "a" file group.


### Setup the file paths to look for
@file_list_sub_paths = (
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7534.CR2", $Bin),
);


### Load the script and verify
$t = $module_name->new(ini_file_path => "ImportPhotosTest.ini");
$td = "Verify the file paths are accurate for set 'a'.";
cmp_deeply($t->list_of_photos_to_move, \@file_list_sub_paths, $td);



################################################################################
# Run test with "b" file set


### Load the new data set.
$h->load_data_samples('b');

@file_list_sub_paths =  (
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7534.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7535.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7536.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7537.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7538.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7539.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7540.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7541.CR2", $Bin),
	sprintf("%s/data-input/input_root_a/5DII/DCIM/100EOS5D/IMG_7542.CR2", $Bin),
);


### Reload the script and run the comparison
$t = $module_name->new(ini_file_path => "ImportPhotosTest.ini");
$td = "Verify the file paths are accurate for set 'b'.";
cmp_deeply($t->list_of_photos_to_move, \@file_list_sub_paths, $td);




################################################################################
# Run test with "d" file set


### Load the new data set.
$h->load_data_samples('d');

@file_list_sub_paths =  (
	sprintf("%s/data-input/input_root_a/S90/DCIM/147___03/MVI_4354.MOV", $Bin),
);


### Reload the script and run the comparison
$t = $module_name->new(ini_file_path => "ImportPhotosTest.ini");
$td = "Verify the file paths are accurate for set 'b'.";
cmp_deeply($t->list_of_photos_to_move, \@file_list_sub_paths, $td);



################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();
