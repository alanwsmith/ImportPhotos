package TestHelper;

################################################################################

=head1 NAME TestHelper.pm

TestHelper - A module that provides an object with reusable methods to aid 
in testing.

Most of the methods should not require modification, but the attributes and
the BUILD method likely will. 

When called, it will automatically write out the default .ini data to 
the defined file location. 

=cut
################################################################################


use Moose;
use MooseX::StrictConstructor;
use MooseX::SemiAffordanceAccessor;
use namespace::autoclean;
use FindBin qw ($Bin);
use File::Path  qw(make_path remove_tree);
use File::Copy;
use File::Copy::Recursive qw(dircopy);
use Carp;
use Test::More;
use Test::Exception;
use Cwd;
use Modern::Perl;


################################################################################
# Setup specifics for this test helper
################################################################################




################################################################################
# Setup Attributes
################################################################################


### define the path to the dir that holds the samples data snapshots
has "sample_data_root_path" => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/sample-data-input", $Bin),
);

### path for the config sampel files root dir
has "sample_configs_root_path" => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/sample-configs", $Bin),
);


### Set the path for the ini file to make.
has 'ini_file_path' => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/ImportPhotosTest.ini", $Bin),
);


### Define the data directory to use if needed
has "data_dir_path" => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/data-input", $Bin),
);

has "data_output_dir_path" => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/data-output", $Bin),
);


### Path for the log directory
has "log_dir_path" => (
	is => "rw",
	isa => "Str",
	default => sprintf("%s/log", $Bin),
);

### Define a default set of directories to remove when cleaning up.
has "dirs_to_remove_on_clean" => (
	is => "rw",
	isa => "ArrayRef",
	default => sub {[]},
);



################################################################################

has "default_output_dir_sub_paths" => (
	is => "rw",
	isa => "ArrayRef",
	default => sub { ["output_root_a", "output_root_b", "output_video_root_a", "output_video_root_b"] }
);



################################################################################
=head2 BUILD

This is called directy when a new instace of the object is created.

=cut
################################################################################


sub BUILD {
	
	### Pull in the self object
	my $self = shift;
	

	### Make sure you are in the test script directory
	$self->move_to_script_dir();

	
	### Setup the directories that should be cleaned
	push @{$self->dirs_to_remove_on_clean}, $self->log_dir_path;
	push @{$self->dirs_to_remove_on_clean}, $self->data_dir_path;
	push @{$self->dirs_to_remove_on_clean}, $self->data_output_dir_path;
	
	### Run a cleanup to make sure you are starting fresh.
	$self->cleanup();
	
	
	### If there is a data sample dir, load the default
	if(-d $self->sample_data_root_path) {
		### load data samples
		$self->load_data_samples();
	}
	
	
	### Make a default update of the ini file
	$self->load_sample_ini();
	
	### Make the default output paths
	$self->build_default_output_dir_sub_paths();
	
	
}



################################################################################
=head2 build_default_output_dir_sub_paths

Used to create the main output paths to be used


=cut
################################################################################

sub build_default_output_dir_sub_paths {

	### Pull in object
	my ($self) = @_;
	
	
	# say "# TestHelper: running: build_default_output_dir_sub_paths()";
	
	for my $sub_path (@{$self->default_output_dir_sub_paths}) {
		
		my $full_path_to_make = sprintf('%s/%s', $self->data_output_dir_path, $sub_path);
		
		if(make_path($full_path_to_make)) {
			# say "# TestHelper: Made: $full_path_to_make";
		}
	}
}



################################################################################
=head2 load_data_samples

Used to load a specific set of data samples into a data directory.

=cut
################################################################################

sub load_data_samples {

	my ($self, $which_sample) = @_;

	### Set which_sample to a default if it isn't defined
	if(!defined($which_sample)) {
		$which_sample = "a";
	}
	
	### First, remove the existing data samples if there are any
	if(-d $self->data_dir_path) {
		unless(remove_tree($self->data_dir_path)) {
			croak "Could not remove existing data dir: " . $self->data_dir_path;
		}
	}
	
	my $full_sample_path = sprintf("%s/%s", $self->sample_data_root_path, $which_sample);
	
	unless(dircopy($full_sample_path, $self->data_dir_path)) {
		croak "Could not copy sample data from: $full_sample_path";
	}

}



################################################################################
=head2 load_main_sample_ini

Used to copy over the ini_sample_path file to the ini_file_path location.

Note that you haven't tested the part where it copies over sample
files that are sent in via arguments. 

=cut
################################################################################

sub load_sample_ini {

	my ($self, $requested_sample) = @_;
	
	### See if you got a reqeust
	if(!defined($requested_sample)) {
		$requested_sample = "default-sample.ini";
	}
	
	### Setup the path.
	my $sample_config_path = sprintf("%s/%s", $self->sample_configs_root_path, $requested_sample);
	
	
	if(!-e $sample_config_path) {
		croak "# TestHelper Missing: $sample_config_path";
	}
	else {
		if(copy($sample_config_path, $self->ini_file_path)) {
			say "# TestHelper: Loaded sample config from: $requested_sample";
		}
	}
	
}



################################################################################
=head2 move_to_script_dir

Makes sure that you are in the testing script directory.

=cut
################################################################################

sub move_to_script_dir {

	my ($self) = @_;

	### Make sure you are in the test directory
	if(!chdir($Bin)) { die "Could not change into test directory: $Bin"; }
	
}





################################################################################
=head2 write_file

write_file( { file => "FILEPATH", data => "STRING"} );

- Attempts to write out a specific set of data to a file. 

- If the directory that is supposed to house the file doesn't exist an
attempt is made to create it. 

- If the writing or the directory creation fails, the function croaks. 

=cut
################################################################################


sub write_file {


	################################################################################
	# Validation configuration.
	
	### define a method_name var to make error messages easier
	my $method_name = "write_data_to_file";
	
	### define the keys
	my %valid_hash_keys = (
		
		data => {
			is_required => 1,
			prevent_empty => 0,
		},
		
		file => {
			is_required => 1,
			prevent_empty => 1,
		},
		
	);
	
	################################################################################
	### Initial load in
	################################################################################
	
	### Choke if too many arguments passed
	croak "Too many arguments passed to $method_name()" if @_ > 2;

	### Make sure you got an argument in addition to self
	unless(@_ == 2) { croak "No arguments passed to $method_name(). Expected a hashref."; }
	
	### pull in the arguments
	my ($self, $arg_hash_ref) = @_;
	
	
	################################################################################
	# Run the validation. You shouldn't have to edit this.
	################################################################################
	
	VALIDATION: {
	
		### Do a simple check to make sure you are getting a hash ref
		unless (ref ($arg_hash_ref) eq "HASH") {
			croak "Argument to $method_name() must be a hash.";
		}	
		
		### Loop through the valid hash keys
		for my $valid_hash_key (keys %valid_hash_keys) {
			
			### See if it's required
			if($valid_hash_keys{$valid_hash_key}{'is_required'}) {
				
				### croak if you can't find it.
				if( !defined($arg_hash_ref->{ $valid_hash_key }) ) {
					croak "Missing required key '" . $valid_hash_key . "' for $method_name().";
				}
				
				### Check to see if it is (and can be) empty.
				elsif ( ($valid_hash_keys{$valid_hash_key}{'prevent_empty'}) && !$arg_hash_ref->{ $valid_hash_key } ) {
					croak "The argument -$valid_hash_key- can not be empty for $method_name().";
				}
			}
		}
		
		### now check to see if any invalid keys were sent
		for my $check_argument_item (keys %{$arg_hash_ref}) {
		
			if( !defined( $valid_hash_keys{$check_argument_item}) ) {
				croak "Invalid key -$check_argument_item- sent to $method_name()";
			}
			
		}
		
	}
	
	
	################################################################################
	# Validation complete, to the work of the method here
	################################################################################
	
	

	### If the file path isn't a full path, make it one
	if( $arg_hash_ref->{"file"} !~ m{ ^ / }xms) {
		my $cwd = getcwd();
		$arg_hash_ref->{"file"} = sprintf("%s/%s", $cwd, $arg_hash_ref->{"file"});
	}


	
	
	### Check to see if the file contains directory info
	if( $arg_hash_ref->{"file"} =~ m{ ^ (.*) / }xms) {
		
		### pull in the directory path
		my $target_directory = $1;
		
		### Check to see if the directory exists
		if(-e $target_directory) {
			### If so, make sure it's actually a directory
			if(!-d $target_directory) {
				croak "File exists where attempting to make a directory: $target_directory";
			}
		}
		
		### otherwise attempt to make it. Croaking if it doesn't work.
		elsif(!make_path($target_directory)) {
			croak "Could not make directory at: $target_directory";
			
			### Note that you probably don't need to croak here since make_path does
			### automatically. 
		}
		
	}
	
	
	### Now, attempt to actually write the file data out.
	open my $OUTPUT_FILE_HANDLE, ">", $arg_hash_ref->{'file'} or croak "Could not open file for writing: " . $arg_hash_ref->{'file'} . "\n";
	print $OUTPUT_FILE_HANDLE $arg_hash_ref->{'data'};
	close $OUTPUT_FILE_HANDLE;	
	
	
}



################################################################################

=head2 remove_ini_file

Usage: 

	$h->remove_ini_file;

=cut
################################################################################



sub remove_ini_file {
	
	my $self = shift;
	
	$self->move_to_script_dir();
	
	if(-e $self->ini_file_path) {
		if(unlink($self->ini_file_path)) {
			return 1;
			# say "# TestHelper: Removed test ini file: " . $self->ini_file_path;
		}
	}
	
	
}




################################################################################
=head2 cleanup

Usage:

	$h->cleanup;
	

Should be called to close out each test.

- Takes no arguments. 

- Removed the "logs" directory in the test directory.

- Removes the "ini_file" as defined in the object.


=cut
################################################################################


sub cleanup {
	
	### Pull in the object self reference
	my $self = shift;
	
	### Make sure you are in the testing directory
	$self->move_to_script_dir();

	### remove the config file if it exists
	$self->remove_ini_file();
	
	### Remove the requested directories
	for my $dir_to_remove (@{$self->dirs_to_remove_on_clean}) {
		if(-d $dir_to_remove) {
			if(remove_tree($dir_to_remove)) {
				# say "# TestHelper: Removed dir: $dir_to_remove";
			}
		}
	}
	
	### Remove the symbolic link for the .pm file. 
	if(-e "../ImportPhotos.pm") {
		unlink("../ImportPhotos.pm");
	}
	
	### Return true for success.
	return 1;
	
}



__PACKAGE__->meta->make_immutable;


1;

__END__
