#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

This example script retrieves the html page from uniprot and extract
information from it.

dependencies:
perl-HTML-Tree

=cut

# print ASCII from HTML from a URL
use LWP::Simple;
use HTML::Parse;
my ($html, $ascii);
$html = get("http://www.uniprot.org/uniprot/Q42435");
defined $html
    or die "Can't fetch HTML from uniprot";

# Retrieve the protein name
$html =~ m/class="FULL">([\D\s]+?)<\/span>/;
my $name = $1;
print "Protein has for name: $name \n";

# Retrieve the protein short name
$html =~ m/Entry name<\/acronym><\/td><td>([\D\s]+?)<\/td>/;
my $shortname = $1;
print "Protein has for short-name: $shortname \n";

# Retrieve the protein's pathways
$html =~ m/Pathway<\/acronym><\/td><td>(.*?)<\/td>/;
my $pathway_string = $1;
my @pathways;
while ($pathway_string =~ m/">(.*?)<\/a>/g){
    push(@pathways, $1);
}

# Iterate through all the pathway found and print the information
foreach my $pathway(@pathways) {
    print "Protein has pathway: $pathway\n";
}
