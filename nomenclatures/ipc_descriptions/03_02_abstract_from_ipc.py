#!/usr/bin/python

import urllib
import json
import sys
import csv
import pprint
import re


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
    serviceurl_ipc = 'http://localhost:8080/pat-clas-service/rest/v1.0/IPC/ancestorsAndSelf?symbol='

    url_ipc = serviceurl_ipc + code
    # we check IPC
    uh = urllib.urlopen(url_ipc)
    data = uh.read()
    js = json.loads(str(data))
    position = {}
    ipc_desc = {}
    ipc_hrchy = {}
    retval = {}
    full_descr = ' '
    ipc_desc['ipc_code'] = ipc_hrchy['ipc_code']  = s

    if js:
        # getting the level of the code
        level_elt = -1
        for elt in js:
            if elt['symbol'] == code and elt['kind'] != 'n':
                level_elt = elt['level']
                #ipc_hrchy['descr'] = elt['textBody'].split('\n', 1)[0]

        for elt in js:
            if elt['level'] <= level_elt and elt['kind'] != 'n':
                if elt['level'] in (0, 1, 2):
                    if elt['level'] == 0:
                        ipc_hrchy['parent'] = elt['symbol']
                        position['section'] = cleanTitles(elt['textBody'][10:])
                    if elt['level'] == 1:
                        position['class'] = cleanTitles(elt['textBody'])
                    if elt['level'] == 2:
                        position['ipc_position'] = ipc_desc[
                            'ipc_position'] = elt['symbol']
                        position['subclass'] = cleanTitles(elt['textBody'])
                        position['full_subclass'] = re.sub(
                            '\n', ' ', elt['textBody'])
                        pp.pprint('prueba')
                    if elt['level'] == level_elt - 1:
                       ipc_hrchy['ancestor'] = elt['symbol']
                else:
                    full_descr += elt['textBody']  # FULL TEXT
                    if elt['kind'] == 'm':
                        full_descr += '. '

    full_descr = re.sub('\n', ' ', full_descr)
    ipc_desc['ipc_desc'] = full_descr[3:] + '.'
    retval[0] = position
    retval[1] = ipc_desc
    retval[2] = ipc_hrchy
    return retval


def dicToCsv(output_file, cvs_columns, dict_data):
    try:
        with open(ofname, 'w') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
            writer.writeheader()
            for data in dict_data:
                writer.writerow(data)
    except IOError as (errno, strerror):
        print("I/O error({0}): {1}".format(errno, strerror))


def cleanTitles(s):
    r = re.sub('\n', ' ', s)
    r = re.sub('[^A-Z ]', '', r)
    return r

pp = pprint.PrettyPrinter(indent=4)
ifname = 'abstract_from_ipc.input.csv'
dict_data = {'pos': [], 'desc': [], 'hrchy': []}

with open(ifname, "rb") as ifile:
    # Reader pipe
    reader = csv.reader(ifile)

    for row in reader:
        res = CheckIPCContext(row[0])
        dict_data['pos'].append(res[0])
        dict_data['desc'].append(res[1])
        dict_data['hrchy'].append(res[2])

    # Create the positions table
    csv_columns = ['ipc_position', 'section', 'class',
                   'subclass', 'full_subclass', 'ipc_version']
    ofname = '01_abstract_from_ipc.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['pos'])

    # Create the full ipc description table
    csv_columns = ['ipc_code', 'ipc_position', 'ipc_desc', 'ipc_version']
    ofname = '02_ipc_description.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['desc'])

    # Create the hierarchy table
    csv_columns = ['ipc_code', 'ancestor', 'parent', 'ipc_version']
    ofname = '03_hierarchy_ipc.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['hrchy'])

    '''
    # Create the simple ipc table
    csv_columns = ['code', 'description', 'ipc_version']
    ofname = 'abstract_from_ipc.output.csv'
    dicToCsv(ofname, csv_columns, dict_data)
    '''
