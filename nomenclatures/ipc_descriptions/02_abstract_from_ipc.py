#!/usr/bin/python

import urllib
import json
import sys
import csv
import pprint
import mysql.connector


# Convert from CPC IPC ref format A63H17/273
# to IPC symbol format A63H0017273000 (zero padded, 4 digit for main
# group, 6 digits for group)
def cpcRefToIpc(s):
    pos_subcode = s.find('/')
    if pos_subcode > 0:
        group = '0000' + s[4:pos_subcode]
        group = group[-4:]
        subgroup = s[pos_subcode + 1:] + '000000'
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

    retval = {}
    full_descr = ' '

    if js:
        # getting the level of the code
        for elt in js:
            if elt['symbol'] == code and elt['kind'] != 'n':
                level_elt = elt['level']
                retval['code'] = code
                retval['descr'] = elt['textBody'].split('\n', 1)[0]

        for elt in js:
            if elt['level'] <= level_elt and elt['kind'] != 'n':

                if elt['level'] == 0:
                    retval['parent'] = elt['symbol']
                if elt['level'] == level_elt - 1:
                    retval['ancestor'] = elt['symbol']

                full_descr = full_descr + ', ' + \
                    elt['textBody'].split('\n', 1)[0]  # JUST THE FIRST LINE
                # full_descr = full_descr + ', ' + elt['textBody'] # FULL TEXT
    return retval  # We remove the first delimiter (first char) and the spaces


pp = pprint.PrettyPrinter(indent=4)
ifname = 'abstract_from_ipc.input.csv'
cnx = mysql.connector.connect(user='your_user', password='your_password',
                              host='127.0.0.1',
                              database='your_database')
cursor = cnx.cursor()
add_ipc_hrchy = ("INSERT IGNORE INTO ipc_hierarchy (code, ancestor, parent)"
                 " VALUES (%s,%s,%s)")
add_ipc = ("INSERT IGNORE INTO ipc (code, description)"
           "VALUES (%s,%s)")

with open(ifname, "rb") as ifile:
    # Reader pipe
    reader = csv.reader(ifile)

    # Loop into input csv to get ipc info and put it in ipc_hierarchy
    # and nomen_ipc tables
    for row in reader:

        res = CheckIPCContext(row[0])
        data_ipc_hrchy = (res['code'], res['ancestor'], res['parent'])
        data_ipc = (res['code'], res['descr'])
        cursor.execute(add_ipc, data_ipc)
        cursor.execute(add_ipc_hrchy, data_ipc_hrchy)

cnx.commit()
cursor.close()
cnx.close()
