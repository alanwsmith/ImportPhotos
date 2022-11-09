#!/usr/bin/perl 

################################################################################
=head1 Test Description

This is just a final cleanup run. Make sure that if you run prove, even if
the last test doesn't clean up after itself, this one will.

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


ok($h->cleanup(), "Final Cleanup Sweep");

done_testing();
