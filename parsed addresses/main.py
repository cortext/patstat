from csv import DictReader, DictWriter
import requests

FNAME = 'export_newaddresses.csv'
ONAME = 'export_newaddresses.parsed_names.csv'
BASE_URL = 'http://local_ip:port/parser'

def libpostal_api(address_text):
    resp = requests.post(BASE_URL,
                         data={'query': address_text})
    data = resp.json()
    return data


def parse_patstat_address(ifile):
    w = open(ONAME, 'w')
    wcsv = DictWriter(w, fieldnames=['name', 'person_id', 'address'])
    wcsv.writeheader()

    for row in ifile:
        person_name = row['person_name']
        list_res = parse_address(person_name)
        array_length = len(list_res)
        res = ''

        for i in range(array_length):
            if i > 0:
                res += list_res[i][0] + ', '

        res = res[:-2]

        try:
            data = {'name': person_name, 'person_id':
                    row['person_id'], 'address': res}
            wcsv.writerow(data)
        except Exception as err:
            print("\t", err)

    w.close

r = open(FNAME)
rcsv = DictReader(r, delimiter='\t')
parse_patstat_address(rcsv)
