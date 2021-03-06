#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

This example script retrieves the xml file from uniprot and extract
information from it.

=cut

use XML::Simple;
use LWP::Simple;
use Data::Dumper;

my $xs1 = XML::Simple->new();

# Retrieve the xml from the website
my $html = get("http://www.uniprot.org/uniprot/Q42435.xml");

# Load xml into memory / into a tree
my $doc = $xs1->XMLin($html);

## What's needed to do what follows:
#print Dumper($doc);

# Retrieve the name
my $name = $doc->{entry}->{protein}->{recommendedName}->{fullName};
print "Protein has for name: $name \n";
