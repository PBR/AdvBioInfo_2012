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
