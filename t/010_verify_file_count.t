#!/usr/bin/perl 

################################################################################
=head1 Test Description

Used to test the file counts that the script will use. 


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
# Start testing
################################################################################


$td = "Initial Load Test";
ok($t = $module_name->new(ini_file_path => "ImportPhotosTest.ini"), $td);



$td = "Make sure there is one file to process.";
is($t->number_of_photos_to_process, 1, $td);

$td = "Make sure there is one file to skip.";
is($t->number_of_files_to_skip, 2, $td);





################################################################################
### Clean up and finish up testing
################################################################################


$h->cleanup();

done_testing();


