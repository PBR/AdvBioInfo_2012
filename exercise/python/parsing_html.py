#!/usr/bin/python
#-*- coding: utf-8 -*-

"""
Parse uniprot's html to extract some information for the protein.
"""

import re
import requests

if __name__ == '__main__':
    # Load the information from uniprot
    html = requests.get('http://www.uniprot.org/uniprot/Q42435')

    # Retrieve the name of the protein
    m = re.search('class="FULL">([\D\s]+?)</span>', html.content)
    name = m.group(1)
    print 'Protein has for name         : %s' % name

    # Retrieve the short name of the protein
    m = re.search('Entry name</acronym></td><td>([\D\s]+?)</td>', html.content)
    short_name = m.group(1)
    print 'Protein has for short name   : %s' % short_name

    # Retrieve the list of pathways to which the protein is known to be
    # involved in
    m = re.search('Pathway</acronym></td><td>(.*?)</td>', html.content)
    pathways = re.findall('">(.*?)</a>', m.group(1))
    print 'Protein has for pathways     : %s' % ', '.join(pathways)
