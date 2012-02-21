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

# Retrieve the sort name
my $shortname = $doc->{entry}->{name};
print "Protein has for short-name: $shortname \n";

# Retrieve the different pathways available.
my @pathways;
my $cnt = 0;
while (my $comment = $doc->{entry}->{comment}[$cnt]){
    $cnt += 1;
    if ( $comment->{type} eq 'pathway'){
        push(@pathways, $comment->{text});
    }
}

# Iterate through all the pathway found and print the information
foreach my $pathway(@pathways) {
    print "Protein has pathway: $pathway\n";
}
