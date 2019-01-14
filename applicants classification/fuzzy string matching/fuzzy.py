import pymysql
import pandas as pd
from sshtunnel import SSHTunnelForwarder
from os.path import expanduser

home = expanduser('~')

# remote database auth
sql_hostname = ''
sql_username = ''
sql_password = ''
sql_main_database = ''
sql_port = ''

# ssh tunnel auth
ssh_host = ''
ssh_user = ''
ssh_pass = ''
ssh_port = ''

localhost = ''
forward_port = ''

# query variables
table_applicants = ''
limit_to_match = 'memory'

with SSHTunnelForwarder(
         (ssh_host, ssh_port),
         ssh_username=ssh_user,
         ssh_password=ssh_pass,
         remote_bind_address=(sql_hostname, sql_port),
         local_bind_address=(localhost, forward_port)) as tunnel:
    conn = pymysql.connect(host=localhost, user=sql_username,
                           passwd=sql_password, db=sql_main_database,
                           port=tunnel.local_bind_port)
    query = 'SELECT * FROM' + table_applicants + ' LIMIT '
    + limit_to_match + ';'

    df = pd.read_sql_query(query, conn)
    cursor = conn.cursor()

    conn.close()
