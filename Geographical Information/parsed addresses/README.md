# Enriching Patstat: Parsing addresses from person_name field

Patstat store the information for applicants and inventors of 89'505.837 millions of applications. Most of this information is accessible in the table tls206_person which contains 54'430.027 millions of distinct addresses. Nevertheless, in almost half of the records the address information is missing, but doing an analysis of those cases wherein the address field was empty it could be determined that in few records the addresses is contained into the field person_name.

## Setting up Libpostal 

Libpostal is a C library for parsing/normalizing street addresses around the world using statistical NLP and open data. To install
the language binding for python you can directly access the documentation [here](https://github.com/openvenues/pypostal). For the present 
script was used a local libpostal-rest instance that was mounted with a [docker container](https://github.com/johnlonganecker/libpostal-rest-docker), 
this make easier and more generic the labor to interact with the library. 

```
docker build -t libpostal-rest .
docker run -d -p 8080:8080 libpostal-rest
```
## Extracting and exporting the data

In the table tls206_person exist 36 million of applicants without location, but barely 5% of those have any information of the address in the person_name field. Therefore, a script was written to catch those records from the person_name field where the value possibly contains an address.

```sql
CREATE TABLE patstatAvr2017_NewAddress
select *, (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', ''))) Nbcomma,
	CASE 
		WHEN TRIM(' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-1)) IN ('JP','US','CA','CANADA','JAPAN','GB','ZA') AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))>3 THEN 
			TRIM(LEADING ' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-3))
		WHEN TRIM(' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-1)) IN ('JP','US','CA','CANADA','JAPAN','GB','ZA') AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))=3 
			 AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, '.', '')))<=1 THEN 
			TRIM(LEADING ' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-2)) 
		WHEN TRIM(' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-1)) IN ('JP','US','CA','CANADA','JAPAN','GB','ZA') AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))=3 
			AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, '.', '')))>1 THEN TRIM(LEADING ' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-3))
		WHEN TRIM(' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-1)) NOT IN ('JP','US','CA','CANADA','JAPAN','GB','ZA') AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))>4 THEN 
			TRIM(LEADING ' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-3))
		WHEN TRIM(' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-1)) NOT IN ('JP','US','CA','CANADA','JAPAN','GB','ZA') AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))<=4 THEN 
			TRIM(LEADING ' ' FROM SUBSTRING_INDEX(replace(person_name,',,',','),',',-2))  
		END address_final 
from patstatAvr2014.tls206_person
where person_name<>"" and person_name is not null AND person_address is null
AND TRIM(' ' FROM SUBSTRING_INDEX(person_name,',',-1)) 
IN ('AE','AL','AR','AT','AU','BA','BD','BE','BG','BM','BO','BR','BS','BY','BZ','CA','CD','CF','CG','CH','CI','CL',
'CM','CN','CR','CU','CZ','DE','DK','DM','DO','DZ','EC','EE','EG','ES','ET','FI','FJ','FR','GA','GB','GR','HK','HU','ID','IE','IL','IN','IQ','IR','IS',
'IT','JM','JO','JP','KE','KG','KH','KP','KR','KW','KZ','LA','LB','LI','LK','LU','LY','MA','MC','MD','ME','MN','MO','MQ','MR','MT','MU','MV','MW','MX',
'NC','NE','NG','NI','NL','NO','NZ','PA','PE','PH','PK','PL','PR','PS','PT','PY','QA','RE','RO','RS','RU','RW','SA','SC','SE','SG','SI','SK','SN','SO',
'SV','SZ','TD','TG','TH','TJ','TN','TO','TR','TT','TW','TZ','UA','US','UY','VE','VN','ZA','Australie','Autriche','Belgique','Canada','États-Unis','Espagne',
'Finlande','France','Inde','Japon','Royaume-Uni','Russie','Suisse','Australia','Austria','Belgium','Brazil','China','Deutschland','Germany','India','Japan',
'Korea','Peoples Republic Of China',"People's Republic Of China",'Republic Of China','Russia','South Korea','Spain','Switzerland','United Kingdom','United States')
AND (LENGTH(person_name) - LENGTH(REPLACE(person_name, ',', '')))>2 ;
```

## Running the script

The python script takes a csv file where the information is read and export it with the parsed addresses into another csv file named as you specify in the script parameter, the input file can be build rely on the previously created table.

```sql
SELECT * FROM patstatAvr2017_NewAddress
INTO OUTFILE '/user/path/export_newaddresses.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\t';
```
Then run

```bash
$ python main.py -f input.csv -o output.csv
```

## Results

Total applicants: 54'430.027 <br/>
Total missing addresses: 66.86% (36'396.141) <br/>
Total parsed addresses: 2.4% (1'308.009)
<br/>

| Ctry Code | tls206_person table | missing addr | parsed addr | 
| --- | --- | --- | --- |
| US | 1'0448.561 | 4'089.722 | 46.918 |
| DE | 3'888.889 | 2'279.019 | 166.479 |
| CN | 2'050.877 | 1'659.627 | 8.047 |
| JP | 4'853.299 | 1'517.810 | 53.361 | 
| FR | 1'632.523 | 871.033 | 12.179 | 
| NULL | 18'565.900 | 18'234.066 | 1'025.757 |
| Total | 54'430.027 | 36'396.141 | 1'308.009 |

