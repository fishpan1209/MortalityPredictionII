#!/usr/bin/env python

import sys
import random

from optparse import OptionParser

parser = OptionParser()
parser.add_option("-n", "--model-num", action="store", dest="n_model",
                  help="number of models to train", type="int")
parser.add_option("-r", "--sample-ratio", action="store", dest="ratio",
                  help="ratio to sample for each ensemble", type="float")

options, args = parser.parse_args(sys.argv)

for line in sys.stdin:
    value=line.strip()
    for i in range(options.n_model):
    	m=random.uniform(0,1)
    	if m<options.ratio:
    		if len(value)>0:
    			print "%d\t%s" % (i, value)
