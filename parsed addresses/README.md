# Enriching Patstat: Parsing the addresses from person_name field

Patstat store the information of more than 60 millions of patent applicants, either natural persons or legal entities, 
most of these these information can be consulted in the table tls206_person. Nevertheless, almost in half of the record 
the address information is missing, but doing an analysis of those cases wherein the address field was empty, it was determined 
that in a few cases the addresses is contained into the field person_name.

## Setting up Libpostal 

Libpostal is a C library for parsing/normalizing street addresses around the world using statistical NLP and open data. To install
the lenguage binding for python can be read directly the documentation [here](https://github.com/openvenues/pypostal). For the present 
script was used a local libpostal-rest instance that was mounted with a [docker container](https://github.com/johnlonganecker/libpostal-rest-docker), 
this make easier and more generic the labor to interact with the library. 

```
docker build -t libpostal-rest .
docker run -d -p 8080:8080 libpostal-rest
```
## Extracting and exporting the data

