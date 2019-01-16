import pymysql
import pandas as pd
from sshtunnel import SSHTunnelForwarder
from os.path import expanduser
import configparser
from fuzzywuzzy import fuzz

config = configparser.ConfigParser()
config.read('config.ini')
home = expanduser('~')

# remote database auth
sql_hostname = config['remotedb']['db_hostname']
sql_username = config['remotedb']['db_username']
sql_password = config['remotedb']['db_password']
sql_main_database = config['remotedb']['db_database']
sql_port = config['remotedb']['db_port']

# ssh tunnel auth
ssh_host = config['sshtunnel']['ssh_host']
ssh_user = config['sshtunnel']['ssh_user']
ssh_pass = config['sshtunnel']['ssh_pass']
ssh_port = config['sshtunnel']['ssh_port']

localhost = config['localhost']['ip']
port_forward = config['localhost']['port_forward']

# query variables
table_applicants = ''
limit_to_match = 'memory'

with SSHTunnelForwarder(
         (ssh_host, ssh_port),
         ssh_username=ssh_user,
         ssh_password=ssh_pass,
         remote_bind_address=(sql_hostname, sql_port),
         local_bind_address=(localhost, port_forward)) as tunnel:
    conn = pymysql.connect(host=localhost, user=sql_username,
                           passwd=sql_password, db=sql_main_database,
                           port=tunnel.local_bind_port)
    query = 'SELECT * FROM' + table_applicants + ' LIMIT '
    + limit_to_match + ';'

    df = pd.read_sql_query(query, conn)
    cursor = conn.cursor()
    for index, row in df.iterrows():
        if(row['doc_std_name']):
            row['doc_std_name'] = row['doc_std_name'].upper()

        ratio = fuzz.token_set_ratio(row['person_name'].upper(),
                                     row['doc_std_name'])

        query = 'INSERT INTO fuzzy_match_list VALUES (%s, %s, %s, %s, %s)'
        new_record = (row['person_id'], row['person_name'],
                      row['doc_std_name_id'], row['doc_std_name'], ratio)
        cursor.execute(query, new_record)
        conn.commit()

    conn.close()
