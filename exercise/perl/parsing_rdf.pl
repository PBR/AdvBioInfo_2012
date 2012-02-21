#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

This example script retrieves the rdf file from uniprot and extract
information from it.

=cut

use RDF::Trine;
use LWP::Simple qw(get);

# Let's define all the ontologies we're going to use here.
my $rdf = RDF::Trine::Namespace->new(
    'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
my $rdfs = RDF::Trine::Namespace->new(
    'http://www.w3.org/2000/01/rdf-schema#');
my $uniprot = RDF::Trine::Namespace->new(
    'http://purl.uniprot.org/core/');


=info
This functions searches for the name of the protein.
To do this it looks for the recommendedName object by looking for the
triple:
?s <http://purl.uniprot.org/core/recommendedName> ?o
The subject is the protein, the object the recommendedName node.

From this node it will look for the fullName by looking for the triple:
recommendedName <http://purl.uniprot.org/core/fullName> ?o
where the object is the fullName. This fullName is saved and return.
=cut
sub getName {
    my $graph = $_[0];
    my $name = '';

    my $iterator = $graph->get_statements(undef,
        $uniprot->recommendedName, undef);

    while (my $statement = $iterator->next) {
        my $object = $statement->object;
        
        my $iterator2 = $graph->get_statements($object,
            $uniprot->fullName, undef);

        while (my $statement2 = $iterator2->next) {
            my $object = $statement2->object;
            $name = $object->as_string;
        }
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
    my $graph = $_[0];
    my $shortname = '';

    my $iterator = $graph->get_statements(undef, $uniprot->mnemonic, undef);

    while (my $statement = $iterator->next) {
        my $object = $statement->object;
        $shortname = $object->as_string;
    }
    return($shortname);
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
    my $iterator = $model->get_statements(undef, $rdf->type,
        $uniprot->Pathway_Annotation);

    while (my $statement = $iterator->next) {

        my $subject = $statement->subject;
        my $pathways = $model->get_statements($subject, $rdfs->comment, undef);

        while (my $path = $pathways->next) {
            my $object = $path->object;
            my $pathway = $object->as_string;
            push(@pathways, $pathway);
        }
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


=for comment
# This piece of code iterates over all the triples in the model and
# prints them.
my $iterator = $model->get_statements(undef, undef, undef);

while (my $statement = $iterator->next) {

    my $subject = $statement->subject;
    my $predicate = $statement->predicate;
    my $object = $statement->object;

    # $thing and $label are RDF::Trine::Node objects. To get a string suitable
    # for printing, use the as_string() method:
    my $subject_string = $subject->as_string;
    my $predicate_string = $predicate->as_string;
    my $object_string = $object->as_string;

    print "$subject_string $predicate_string $object_string\n";
}
=cut 
