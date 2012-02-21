#!/usr/bin/python
#-*- coding: utf-8 -*-

"""
Parse uniprot's xml to extract some information for the protein.
"""

import requests
from StringIO import StringIO
from lxml import etree

if __name__ == '__main__':
    # Load the information from uniprot
    xml = requests.get('http://www.uniprot.org/uniprot/Q42435.xml')
    # Remove the reference to the xml schema in the second line of the
    # file, it confuses lxml
    content = xml.content.split('\n')
    content[1] = '<uniprot>'
    xml_tree = etree.fromstring('\n'.join(content))

    # Retrieve the name of the protein
    names = []
    for name in xml_tree.xpath('entry/protein/recommendedName/fullName'):
        names.append(name.text)
    print 'Protein has for name         : %s' % ', '.join(names)

    # Retrieve the short name of the protein
    short_names = []
    for short_name in xml_tree.xpath('entry/name'):
        short_names.append(short_name.text)
    print 'Protein has for short name   : %s' % ', '.join(short_names)

    # Retrieve the list of pathways to which the protein is known to be
    # involved in
    pathways = []
    for annotation in xml_tree.xpath('entry/comment'):
        if annotation.attrib['type'] == 'pathway':
            for element in annotation.xpath('text'):
                pathways.append(element.text)
    print 'Protein has for pathways     : %s' % ', '.join(pathways)
