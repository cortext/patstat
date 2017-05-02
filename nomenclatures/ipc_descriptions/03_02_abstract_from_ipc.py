#!/usr/bin/python

import urllib
import json
import sys
import csv
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
    code = cpcRefToIpc(s.replace(" ", ""))
    serviceurl_ipc = 'http://localhost:8080/pat-clas-service/rest/v1.0/IPC/ancestorsAndSelf?symbol='

    url_ipc = serviceurl_ipc + code
    # we check IPC
    uh = urllib.urlopen(url_ipc)
    data = uh.read()
    js = json.loads(data.decode("ascii", "ignore"))
    position = {}
    ipc_desc = {}
    ipc_hrchy = {}
    ipc = {}
    retval = {}
    full_descr = ' '
    ipc_desc['ipc_code'] = ipc['ipc_code'] = ipc_hrchy['ipc_code'] = s
    position['ipc_version'] = ipc_desc['ipc_version'] = ipc[
        'ipc_version'] = ipc_hrchy['ipc_version'] = '2016.01'

    if js:
        # getting the level of the code
        ipc_desc['level'] = -1
        for elt in js:
            if elt['symbol'] == code:
                ipc_desc['level'] = elt['level']
                ipc['description'] = elt['textBody'] + '.'

        for elt in js:
            if elt['level'] <= ipc_desc['level']:
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
                        full_subclass= re.sub(
                            '\n', ' ', elt['textBody'])
                        position['full_subclass']  =  full_subclass.replace('"', '')
                else:
                    full_descr += ' ' + elt['textBody']
                    if elt['level'] == ipc_desc['level'] - 1:
                        ipc_hrchy['ancestor'] = elt['symbol']

    if full_descr != ' ':
        full_descr = re.sub('\n', ' ', full_descr)
        full_descr = addDot(full_descr)
        ipc_desc['ipc_desc'] = full_descr[4:] + '.'
        ipc_desc['ipc_desc'] = cleanText(ipc_desc['ipc_desc'])

    retval[0] = position
    retval[1] = ipc_desc
    retval[2] = ipc
    retval[3] = ipc_hrchy
    return retval


def dicToCsv(output_file, cvs_columns, dict_data):
    try:
        with open(ofname, 'w') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=csv_columns,
                                    delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writeheader()
            for data in dict_data:
                writer.writerow(data)
    except IOError as (errno, strerror):
        print("I/O error({0}): {1}".format(errno, strerror))


def cleanTitles(s):
    r = re.sub('\n', ' ', s)
    r = re.sub("\s\s+", " ", r)
    output = ' '.join(w for w in r.split(" ") if w.isupper())
    output = output.title()
    return output


def cleanText(s):
    cleaned = s.replace(", ,", "")
    cleaned = cleaned.replace(",,", ",")
    cleaned = cleaned.replace(" ,", ",")
    cleaned = cleaned.replace(". .", "")
    cleaned = cleaned.replace("..", ".")
    cleaned = cleaned.replace(" . ", ". ")
    cleaned = re.sub("\s\s+", " ", cleaned)
    cleaned = cleaned.replace(",.", ".")
    cleaned = cleaned.replace(".,", ".")
    cleaned = cleaned.replace(" .", ".")
    cleaned = cleaned.replace(" ,", ",")
    cleaned = cleaned.replace(":.", ":")
    cleaned = cleaned.replace("-.", "-")
    result = re.sub(ur"(?!^)(?=\.\s[A-Z]{1})", "\1", s)
    return cleaned


def addDot(s):
    result = re.sub(ur"(?!^)(?=\s[A-Z])", ". ", s)
    return result

ifname = '03_01_abstract_from_ipc_input.csv'
dict_data = {'pos': [], 'desc': [], 'hrchy': [], 'ipc': []}

with open(ifname, "rb") as ifile:
    # Reader pipe
    reader = csv.reader(ifile)

    for row in reader:
        res = CheckIPCContext(row[0])
        dict_data['pos'].append(res[0])
        dict_data['desc'].append(res[1])
        dict_data['ipc'].append(res[2])
        dict_data['hrchy'].append(res[3])

    # Create the ipc positions table
    csv_columns = ['ipc_position', 'section', 'class',
                   'subclass', 'full_subclass', 'ipc_version']
    ofname = '01_ipc_position.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['pos'])

    # Create the full ipc description table
    csv_columns = ['ipc_code', 'ipc_position',
                   'ipc_desc', 'level', 'ipc_version']
    ofname = '02_ipc_description.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['desc'])

    # Create the simple ipc table
    csv_columns = ['ipc_code', 'description', 'ipc_version']
    ofname = '03_ipc_list.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['ipc'])

    # Create the hierarchy ipc table
    csv_columns = ['ipc_code', 'ancestor', 'parent', 'ipc_version']
    ofname = '04_ipc_hierarchy.output.csv'
    dicToCsv(ofname, csv_columns, dict_data['hrchy'])
