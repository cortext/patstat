#!/usr/bin/python

import draftlog
import requests
import csv
import json
import sys
import re
import os

draft = draftlog.inject()

SERVICE_URL = 'http://localhost:8081/rest/v1.0/IPC/ancestorsAndSelf'
IPC_DB_VERSION = '2017.01'
INPUT_FILENAME = 'ipc_codes_input.csv'
RESULT_FOLDER = 'results'

s = requests.Session()

def getAPIResponse(symbol):
    payload = { 'symbol': symbol }
    result = s.get(SERVICE_URL, params=payload)
    return result.json()


# Convert from CPC IPC ref format A63H17/273
# to IPC symbol format A63H0017273000 (zero padded, 4 digit for main
# group, 6 digits for group)
# Formatting like this for 2016 API
def formatCPCtoIPC(symbol):
    """
    Converts a symbol from CPC format (e.g. A63H17/273) to IPC format (e.g.
    A63H0017273000)

    Adds zero padding and removes the slash character from a CPC symbol so that
    it complies with the format required by t3as.

    As an example, the resulting symbol for A63H17/273 would be
    A63H0017273000:'A63H' stays as-is, '17' becomes '0017', '/' is removed and
    '273' becomes 273000.

    The first four characters are left as they are, then if the original symbol
    contains a '/', characters before the '/' are zero padded left to form a 4
    character string and characters after the '/' are zero padded right to form
    a 6 character string. If no '/' is present, whatever comes after the first
    four characters is zero padded left to form a 4 character string, and zeroes
    are used for the remaining 6 characters.

    If the input string does not contain a '/' and it is less than 4 characters
    long, no transformation is applied.

    Parameters
    ----------
    symbol : string
        Symbol to be converted

    Returns
    -------
    string
        Symbol in the required format
    """

    pos_subcode = symbol.find('/')
    if pos_subcode > 0:
        # Pad to the left and cut
        group = '0000' + symbol[4:pos_subcode]
        group = group[-4:]
        # Pad to the right and cut
        subgroup = symbol[pos_subcode + 1:] + '000000'
        subgroup = subgroup[0:6]
        return symbol[0:4] + group + subgroup
    elif len(symbol) > 4:
        # Pad to the left and cut
        group = '0000' + symbol[4:]
        group = group[-4:]
        return symbol[0:4] + group + '000000'
    else: # unknown format
        return symbol


# A description is:
# ipc_position: The position that the IPC symbol belongs to. This is the symbol of the 3rd level.
# ipc_desc: All the concatenate descriptions of the levels below the 3rd.
# level: The level that the IPC symbol belongs to.
def makeIPCDescription(symbolInfo):
    """
    Constructs a 'description' for the symbol (ipc_position, ipc_desc, level)
    without the attributes it shares with the other structures. Assumes
    symbolInfo is sorted by its members' 'level' value.

    A 'description' for a symbol consists in:
    - ipc_class_level: IPC symbol
    - ipc_position: The position that the IPC symbol belongs to. This is the
      symbol of the 3rd level.
    - ipc_desc: All the concatenate descriptions of the levels below the 3rd.
    - level: The level that the IPC symbol belongs to.
    - version: The IPC classification version used to query the data.

    This function takes an array with the information provided by the API for
    the symbol and its parts (sorted by level) and constructs a dictionary with
    'ipc_position', 'ipc_desc' and 'level'

    Parameters
    ----------
    symbolInfo : array<dict>
        Information about the symbol's parts sorted by level.

    Returns
    -------
    dict 
        A dictionary with the symbol's corresponding 'ipc_position', 'ipc_desc'
        and 'level'
    """
    ipc_position = symbolInfo[2]['symbol']

    ipc_desc = ''
    # Below the third level
    for element in symbolInfo[3:]:
        # Clean and append
        elementText = element['textBody'].replace('\n', ' ')
        ipc_desc += elementText + ' '
    
    # Format if there's anything to format
    if ipc_desc:
        ipc_desc = addDot(ipc_desc[:-1]) + '.'
        ipc_desc = cleanText(ipc_desc)

    # Symbol's level. It is in the array's last element.
    ipc_level = symbolInfo[-1]['level']

    return {
        'ipc_position': ipc_position,
        'ipc_desc': ipc_desc,
        'level': ipc_level
    }


# ipc_position: the first three levels symbol.
# section: The title of the level, that means only the first part of the description (Uppercases).
# class: The same as section.
# subclass: The same as section.
# full_subclass: The complete description of the subclass level (Uppercase and lower cases).
def makeIPCPosition(symbolInfo):
    """
    Constructs a 'position' for the symbol (ipc_position, section, class,
    subclass, full_subclass) without the attributes it shares with the other
    structures. Assumes symbolInfo is sorted by its members' 'level' value.

    A 'description' for a symbol consists in:
    - ipc_position: the first three levels symbol.
    - section: The title of the level, that means only the first part of the
      description (Uppercases).
    - class: The same as section.
    - subclass: The same as section.
    - full_subclass: The complete description of the subclass level (Uppercase
      and lower cases).

    This function takes an array with the information provided by the API for
    the symbol and its parts (sorted by level) and constructs a dictionary with
    'ipc_position', 'section', 'class', 'subclass' and 'full_subclass'.

    Parameters
    ----------
    symbolInfo : array<dict>
        Information about the symbol's parts sorted by level.

    Returns
    -------
    dict
        A dictionary with the symbol's corresponding 'ipc_position', 'section',
        'class', 'subclass' and 'full_subclass'.
    """

    # symbol up to the 3rd level
    ipc_position = symbolInfo[2]['symbol']

    # section, class and subclass from first 3 parts of symbol information (uppercase, cleanes)
    ipc_section = cleanTitles(symbolInfo[0]['textBody'])
    ipc_class = cleanTitles(symbolInfo[1]['textBody'])
    ipc_subclass = cleanTitles(symbolInfo[2]['textBody'])

    # full text of 3rd level without \ns and "s
    ipc_full_subclass = symbolInfo[2]['textBody'].replace('\n', ' ').replace('"', '')

    return {
        'ipc_position': ipc_position,
        'section': ipc_section,
        'class': ipc_class,
        'subclass': ipc_subclass,
        'full_subclass': ipc_full_subclass,
    }


# description: The direct, simple description of the international patent classification
def makeIPCListItem(symbolData):
    """
    Constructs a list item for the symbol (description) without the attributes
    it shares with the other structures. Assumes symbolInfo is sorted by its
    members' 'level' value.

    A list item for a symbol consists in:
    - description: The direct, simple description of the international patent
      classification

    This function takes an array with the information provided by the API for
    the symbol and its parts (sorted by level) and constructs a dictionary with
    'description'.

    Parameters
    ----------
    symbolInfo : array<dict>
        Information about the symbol's parts sorted by level.

    Returns
    -------
    dict
        A dictionary with the symbol's corresponding 'description'.
    """

    # It is the textBody of the array's last element (the one with the highest level is the one that was asked for)
    ipc_description = symbolData[-1]['textBody'].replace('\n', ' ') + '.'

    return {
        'description': ipc_description,
    }


# ancestor: The preceding level of the ipc_class_level (previous level)
# parent: The symbol of the section level (first level)
def makeIPCHierarchy(symbolInfo):
    """
    Constructs a 'hierarchy' dictionary for the symbol (ancestor, parent)
    without the attributes it shares with the other structures. Assumes 
    symbolInfo is sorted by its members' 'level' value.

    A list item for a symbol consists in:
    - ancestor: The preceding level of the ipc_class_level (previous level)
    - parent: The symbol of the section level (first level)

    This function takes an array with the information provided by the API for
    the symbol and its parts (sorted by level) and constructs a dictionary with
    'parent' and 'ancestor'.

    Parameters
    ----------
    symbolInfo : array<dict>
        Information about the symbol's parts sorted by level.

    Returns
    -------
    dict
        A dictionary with the symbol's corresponding 'parent' and 'ancestor'.
    """

    # The first one
    ipc_parent = symbolInfo[0]['symbol']
    # As the last element is the one that was asked for, the ancestor is the one before the last, so -2
    ipc_ancestor = symbolInfo[-2]['symbol']

    return {
        'parent': ipc_parent,
        'ancestor': ipc_ancestor
    }


def getIPCStructures(rawSymbol):
    """
    Constructs the structures for a given symbol based on what the API responds
    for that symbol.

    Asks the API about the given symbol, then constructs dictionaries for all of
    the structures (description, position, list_item, hierarchy) based on the
    response and returns them in an array.

    Parameters
    ----------
    rawSymbol : string
        Symbol as it comes from the input

    Returns
    -------
    array<dict>
        An array with the structures corresponding to the input symbol in the
        following order:
        [1] ipc_position
        [2] ipc_description
        [3] ipc_list_item
        [4] ipc_hierarchy
    """

    # Symbol comes with spaces from Patstat
    symbol = rawSymbol.replace(" ", "")
    apiResponse = getAPIResponse(symbol)

    # Initialize result objects
    ipc_position = {}
    ipc_description = {}
    ipc_hierarchy = {}
    ipc_list_item = {}

    # Check if the API returned something
    if apiResponse:
        # Sort response array by 'level' for easier result construction
        symbolData = sorted(apiResponse, key=lambda element: element['level'])
        # Fill result objects
        ipc_position = makeIPCPosition(symbolData)
        ipc_description = makeIPCDescription(symbolData)
        ipc_list_item = makeIPCListItem(symbolData)
        ipc_hierarchy = makeIPCHierarchy(symbolData)

    # Add original symbol where it's required
    ipc_description['ipc_class_level'] = rawSymbol
    ipc_list_item['ipc_class_level'] = rawSymbol
    ipc_hierarchy['ipc_class_level'] = rawSymbol

    # Arrange results
    result = [
        ipc_position,
        ipc_description,
        ipc_list_item,
        ipc_hierarchy
    ]

    # Add IPC version to all of the structures
    for structure in result:
        structure['ipc_version'] = IPC_DB_VERSION

    return result


def writeToCSV(output_filename, csv_columns, data):
    """
    Writes an array to a tab-separated csv file in the results directory.

    Writes an array of dictionaries to a csv file in the results directory.
    The resulting file will be tab-separated.
    Tries to create this directory if it does not exist.

    Parameters
    ----------
    output_filename : string
        name of the file
    csv_columns : array<string>
        column names for the csv file
    data : array<dict>
        information to write on the file. the keys of each item in this array
        must be in csv_columns.
    """
    try:
        # Create folder if it does not exist
        if not os.path.exists(RESULT_FOLDER):
            try:
                os.makedirs(RESULT_FOLDER)
            except OSError as e:
                if e.errno != os.errno.EEXIST:
                    raise
        filename = os.path.join(RESULT_FOLDER, output_filename)
        with open(filename, mode='w') as csvfile:
            writer = csv.DictWriter(csvfile,
                                    fieldnames=csv_columns,
                                    delimiter='\t',
                                    quotechar='"',
                                    quoting=csv.QUOTE_MINIMAL)
            writer.writeheader()
            for record in data:
                writer.writerow(record)
    except IOError as e:
        print("I/O error({0}): {1}".format(e.errno, e.strerror))


def cleanTitles(s):
    """
    Cleans a title string

    Replaces all '\n' with blank spaces and reduces multiple blank spaces to
    only one. Only keeps the uppercase part of the original string and returns
    it formatted as title i.e. each word's first letter is uppercase.

    Parameters
    ----------
    s : string
        text to clean

    Returns
    -------
    string
        Original uppercase text with blank spaces instead of linebreaks and
        multiple spaces reduced to single space. Formatted as title (words'
        first letters are uppercase)
    """

    r = re.sub('\n', ' ', s)
    r = re.sub(r"\s\s+", " ", r)
    output = ' '.join(w for w in r.split(" ") if w.isupper())
    output = output.title()
    return output


def cleanText(s):
    """
    Cleans multiple and inconsistent punctuation signs and spaces.

    Parameters
    ----------
    s : string
        text to clean

    Returns
    -------
    string
        Original text without some formatting mistakes found in the API output.

    """
    cleaned = s.replace(", ,", "")
    cleaned = cleaned.replace(",,", ",")
    cleaned = cleaned.replace(" ,", ",")
    cleaned = cleaned.replace(". .", "")
    cleaned = cleaned.replace("..", ".")
    cleaned = cleaned.replace(" . ", ". ")
    cleaned = re.sub(r"\s\s+", " ", cleaned)
    cleaned = cleaned.replace(",.", ".")
    cleaned = cleaned.replace(".,", ".")
    cleaned = cleaned.replace(" .", ".")
    cleaned = cleaned.replace(" ,", ",")
    cleaned = cleaned.replace(":.", ":")
    cleaned = cleaned.replace("-.", "-")
    return cleaned


def addDot(s):
    """
    Adds a dot and space before every uppercase letter that comes after a space

    Parameters
    ----------
    s : string
        text to format

    Returns
    -------
    string
        Original text with dots before every uppercase letter that comes after
        a space.
    """
    result = re.sub(r"(?!^)(?=\s[A-Z])", ". ", s)
    return result


# This writes the results to files
def exportResults(results):
    # write 'position' structures to CSV file
    csv_columns = [
        'ipc_position', 'section', 'class',
        'subclass', 'full_subclass', 'ipc_version'
    ]
    ofname = '01_ipc_position.output.csv'
    writeToCSV(ofname, csv_columns, results['position'])

    # write 'description' structures to CSV file
    csv_columns = [
        'ipc_class_level', 'ipc_position', 'ipc_desc',
        'level', 'ipc_version'
    ]
    ofname = '02_ipc_description.output.csv'
    writeToCSV(ofname, csv_columns, results['description'])

    # write ipc symbol list to CSV file
    csv_columns = [ 'ipc_class_level', 'description', 'ipc_version' ]
    ofname = '03_ipc_list.output.csv'
    writeToCSV(ofname, csv_columns, results['list_item'])

    # write 'hierarchy' structures to CSV file
    csv_columns = [ 'ipc_class_level', 'ancestor', 'parent', 'ipc_version' ]
    ofname = '04_ipc_hierarchy.output.csv'
    writeToCSV(ofname, csv_columns, results['hierarchy'])


# Entry point
def init():
    with open(INPUT_FILENAME, mode="r") as ifile:
        # parse csv file
        reader = csv.reader(ifile)

        # skip header row
        next(reader)

        # print updatable output
        line = draft.log('0 rows processed')

        results = {
            'position': [], 'description': [],
            'hierarchy': [], 'list_item': []
        }

        for index, row in enumerate(reader):

            # consctruct structures
            res = getIPCStructures(row[0])
            results['position'].append(res[0])
            results['description'].append(res[1])
            results['list_item'].append(res[2])
            results['hierarchy'].append(res[3])

            # update output
            line.update(str(index) + ' rows processed')

        exportResults(results)


init()