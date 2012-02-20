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
