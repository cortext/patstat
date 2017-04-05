#!/usr/bin/python

import urllib
import json
import sys
import csv
import pprint

pp = pprint.PrettyPrinter(indent=4)

# Convert from CPC IPC ref format A63H17/273
# to IPC symbol format A63H0017273000 (zero padded, 4 digit for main group, 6 digits for group)
def cpcRefToIpc(s):
    pos_subcode = s.find('/')
    if pos_subcode > 0:
        group = '0000' + s[4:pos_subcode]
        group = group[-4:]
        subgroup = s[pos_subcode+1:] + '000000'
        subgroup = subgroup[0:6]
        return s[0:4] + group + subgroup
    elif len(s) > 4:
        group = '0000' + s[4:]
        group = group[-4:]
        return s[0:4] + group + '000000'
    else:
        return s

# Get IPC context and, if exists, return IPC id    
def CheckIPCContext(s):
    code = cpcRefToIpc(s)
    serviceurl_ipc = 'http://pat-clas.t3as.org/pat-clas-service/rest/v1.0/IPC/ancestorsAndSelf?symbol='
    url_ipc = serviceurl_ipc + code
    # we check IPC
    uh = urllib.urlopen(url_ipc)
    data = uh.read()
    js = json.loads(str(data))
    #pp.pprint(js)
    retval = ''

    if js:
        # getting the level of the code
        for elt in js:
            if elt['symbol'] == code and elt['kind'] != 'n':
                level_elt = elt['level']
        
        for elt in js:
            if elt['level'] <= level_elt and elt['kind'] != 'n':
                #pp.pprint(elt)
                retval = retval + ', ' + elt['textBody'].split('\n', 1)[0] # JUST THE FIRST LINE
                #retval = retval + ', ' + elt['textBody'] # FULL TEXT
    
    return retval[1:].strip() # We remove the first delimiter (first char) and the spaces

ifname = 'abstract_from_ipc.input.csv'
ofname = 'abstract_from_ipc.output.csv'

with open(ifname, "rb") as ifile:
    # Reader pipe
    reader = csv.reader(ifile)
    with open(ofname, "wb") as ofile:
        # Writer pipe
        writer = csv.writer(ofile, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # CSV Headers
        writer.writerow(['ipc', 'description'])
        # Loop into input csv to get ipc text and put it in output csv file
        for row in reader:
            res = CheckIPCContext(row[0]) 
            writer.writerow([row[0], res])


