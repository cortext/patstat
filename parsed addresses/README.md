# Enriching Patstat: Parsing the addresses from person_name field

Patstat store the information of more than 50 millions of patent applicants, either natural persons or legal entities, most of this information can be consulted in the table tls206_person. Nevertheless, in almost in half of the records the address information is missing, but doing an analysis of those cases wherein the address field was empty it could be determined that in few records the addresses is contained into the field person_name.

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

In the table tls206_person exist 36 million of applicants without location, but barely less than 10% of those have any information of the address in the person_name field. Therefore, was wrote a script to catch those records from the person_name field where the value possibly contains an address.

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

The python script takes a csv file to read the information and export it with the parsed addresses into another csv file called 'export_newaddresses.parsed_names.csv', the input file can be build
rely on the table prevously created. 

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

Most repeated countries in the missing set: 

US: 4'089.722 <br/> 
DE: 2'279.019 <br/>
CN: 1'659.627 <br/>
JP: 1'517.810 <br/>
FR: 8'71.033 <br/>
NULL: 18'234.066 

Most repeated countries in the parsed addresses set:

DE:	166.479 <br/>
JP:	53.361 <br/>
US:	46.918 <br/>
FR:	12.179 <br/>
NULL: 1'025.757
