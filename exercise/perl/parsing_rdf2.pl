#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

This example script retrieves the rdf file from uniprot and extract
information from it.

=cut

use RDF::Trine;
use RDF::Query;
use LWP::Simple qw(get);


=info
This functions searches for the name of the protein using a sparql query.

=cut
sub getName{
    my $model = $_[0];
    my $query = new RDF::Query ( <<"END", undef, undef, 'sparql' );
prefix uniprot:<http://purl.uniprot.org/core/>
SELECT ?name
WHERE {
    ?s uniprot:recommendedName ?o .
    ?o uniprot:fullName ?name .
}
END

    my $iterator = $query->execute( $model );
    my $name;
    while (my $row = $iterator->next) {
        #$row is a HASHref containing variable name -> RDF Term bindings
        $name = $row->{'name'}->as_string;
    }
    return($name);
}

=info
This function find the triple similar to
?s <http://purl.uniprot.org/core/mnemonic> ?o.
The object of this triple is the short name of the protein which is the
subject.

Return the short name (object).
=cut
sub getShortName {
    my $model = $_[0];
    my $query = new RDF::Query ( <<"END", undef, undef, 'sparql' );
prefix uniprot:<http://purl.uniprot.org/core/>
SELECT ?name 
WHERE {
    ?s uniprot:mnemonic ?name .
}
END

    my $iterator = $query->execute( $model );
    my $name;
    while (my $row = $iterator->next) {
        #$row is a HASHref containing variable name -> RDF Term bindings
       $name = $row->{'name'}->as_string;
    }
    return($name);
}

=info
This function finds all the subject which have for type
<http://purl.uniprot.org/core/Pathway_Annotation>.

For all these subject, find the one which have a comment 
<http://www.w3.org/2000/01/rdf-schema#comment>
Append these comments (which are the name of the pathways) to the list
of pathways.
Return this list of pathways.
=cut
sub getPathways {
    my $model = $_[0];
    my @pathways;
    my $query = new RDF::Query ( <<"END", undef, undef, 'sparql' );
prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#>
prefix uniprot:<http://purl.uniprot.org/core/>
SELECT ?pathway
WHERE {
    ?annotation a uniprot:Pathway_Annotation .
    ?annotation rdfs:comment ?pathway .
}
END

    my $iterator = $query->execute( $model );
    while (my $row = $iterator->next) {
        #$row is a HASHref containing variable name -> RDF Term bindings
        my $path = $row->{'pathway'}->as_string;
        push(@pathways, $path);
    }
    return(@pathways);
}

# The url of the rdf file for the protein of interest on uniprot
my $url = 'http://www.uniprot.org/uniprot/Q42435.rdf';
# Generate a temporary store in which to store the graph
my $store = RDF::Trine::Store::DBI->temporary_store();
# Create an empty graph model within the store
my $model = RDF::Trine::Model->new( $store );
# Loads the graph with the data from the url
RDF::Trine::Parser->parse_url_into_model( $url, $model );


# Call our functions to retrieve information
my $name = getName($model);
print "Protein has for name: $name \n";
my $shortname = getShortName($model);
print "Protein has for short-name: $shortname \n";
my @pathways = getPathways($model);

# Iterate through all the pathway found and print the information
foreach my $pathway(@pathways) {
    print "Protein has pathway: $pathway\n";
}
