#!/usr/bin/perl

################################################################################
=head1 exif-report-helper.pl

This script produces a report of key EXIF data for all the necessary 
files in the sample directory tree.


=cut
################################################################################

use Modern::Perl;
use Image::ExifTool qw(:Public);
use FindBin qw($Bin);
use File::Find;
use YAML::XS;


### Directory to process
my $sample_data_dir = sprintf("%s/sample-data-input", $Bin);

### File extensions to allow
my %valid_extensions = (
	'cr2' => 1,
	'mov' => 1,
	'jpg' => 1,
	'crw' => 1,
	'avi' => 1,
	'png' => 1,
	
);

### Temporary var to hold output data
my $output_string = "";

say "Starting exif-report-helper.";

find(\&wanted, $sample_data_dir);


open my $OUTPUTHANDLE, ">", sprintf("%s/exif-report.txt", $Bin) or die "Could not open exif-report.txt";
print $OUTPUTHANDLE $output_string;
close $OUTPUTHANDLE;

say "exif-report.txt created. Process complete.";


sub wanted {
	
	### pull out just the file name
	my $just_file_name = $_;
	
	### Pull in the full file name
	my $full_file_path = $File::Find::name;
	
	### Kick back if it's a directory
	return if -d $full_file_path;
	
	### Pull in the file extension
	my ($file_extension) = $full_file_path =~ m{ \. ([^\.]+)$ }xms;
	
	### Only process if it's a valid extension
	if(defined($valid_extensions{lc($file_extension)})) {
		
		### Create a path for the text file to store the full output for the file. 
		(my $exif_dump_file_path = $full_file_path) =~ s{\.\w+$}{.txt};
		
		### Create the hash that will be dumped out
		my %hash_to_output;
		
		### Make a better formatted filename
		($hash_to_output{ActiveFile} = $full_file_path) =~ s{$sample_data_dir}{}xms;
		
		say "Processing: $hash_to_output{ActiveFile}";
		
		### Pull in the exif data
		my $exif_info = ImageInfo($full_file_path);
		
		### Write out the full exif data dump file
		open my $DUMPFILE, '>', $exif_dump_file_path or die "Could not open $exif_dump_file_path";
		print $DUMPFILE Dump $exif_info;
		close $DUMPFILE;
		
		
		$hash_to_output{"CreateDate_______"} = $exif_info->{CreateDate};
		$hash_to_output{"DateTimeOriginal_"} = $exif_info->{DateTimeOriginal};	
		$hash_to_output{"FileModifyDate___"} = $exif_info->{FileModifyDate};
		
		
		$output_string .= Dump \%hash_to_output;
		$output_string .= "\n";
			
	}
}


