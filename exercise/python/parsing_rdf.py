#!/usr/bin/python
#-*- coding: utf-8 -*-

"""
Parse uniprot's rdf to extract some information for the protein.
"""

import rdflib
from rdflib import Namespace

# Define some of the ontology we are going to use:
RDF = Namespace('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
RDFS = Namespace('http://www.w3.org/2000/01/rdf-schema#')
UNIPROT = Namespace('http://purl.uniprot.org/core/')


def get_protein_name(graph):
    """ From the provided uniprot graph return the name of the protein.
    To retrieve the name this methods looks for the object to which the
    predicates <http://purl.uniprot.org/core/recommendedName> points.
    Then the name is the object of the triples having for subject the
    object of the previous triple and for predicates
    <http://purl.uniprot.org/core/fullName>

    @param graph, a rdflib Graph object containing the information
    retrieved from Uniprot for a protein.
    """
    names = []
    for protein in g.objects(None, UNIPROT['recommendedName']):
        for name in g.objects(protein, UNIPROT['fullName']):
            names.append(str(name))
    return names


def get_protein_short_name(graph):
    """ From the provided uniprot graph return the short name of the
    protein.
    The short name is the object to which the predicates
    <http://purl.uniprot.org/core/mnemonic> points.

    @param graph, a rdflib Graph object containing the information
    retrieved from Uniprot for a protein.
    """
    short_names = []
    for short_name in g.objects(None, UNIPROT['mnemonic']):
        short_names.append(str(short_name))
    return short_names


def get_protein_pathways(graph):
    """ From the provided uniprot graph return the pathways in which the
    protein is involved (or known to be involved).
    To do so, the methods finds all the annotation which are of type
    <http://purl.uniprot.org/core/Pathway_Annotation> and retrieve the
    object of the predicate 
    <http://www.w3.org/2000/01/rdf-schema#comment> as they are the name
    of the pathway.

    @param graph, a rdflib Graph object containing the information
    retrieved from Uniprot for a protein.
    """
    pathways = []
    for annotation in g.subjects(RDF['type'],
        UNIPROT['Pathway_Annotation']):
        for pathway in g.objects(annotation, RDFS['comment']):
            pathways.append(str(pathway))
    return pathways


if __name__ == '__main__':
    # Create a graph
    g = rdflib.Graph()
    # Load the information from uniprot
    graph = g.parse('http://www.uniprot.org/uniprot/Q42435.rdf')
    
    # Retrieve information from the graph
    names = get_protein_name(graph)
    print 'Protein has for name         : %s' % ', '.join(names)
    short_names = get_protein_short_name(graph)
    print 'Protein has for short name   : %s' % ', '.join(short_names)
    pathways = get_protein_pathways(graph)
    print 'Protein has for pathways     : %s' % ', '.join(pathways)
