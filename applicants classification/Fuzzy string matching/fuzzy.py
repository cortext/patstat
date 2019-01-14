import pymysql
import pandas as pd
from sshtunnel import SSHTunnelForwarder
from os.path import expanduser

home = expanduser('~')
sql_hostname = ''
sql_username = ''
sql_password = ''
sql_main_database = ''
sql_port = ''
ssh_host = ''
ssh_user = ''
ssh_pass = ''
ssh_port = '' 
