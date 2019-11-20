# Enriching patstat with geographical information

This collection of scripts aims to document how we enrich patstat with geographical information about applicants and inventors, obtained using CorText's geocoding and mapping tools.

We want to get coordinates, urban/rural area and NUTS3 classification information for the set of addresses we have in the tables applt_addr and invt_addr. In order to get there, we need to use two of CorText's scripts: geocoding and geospatial exploration, one after the other.

With geocoding, we get the coordinates along with some other fields, and then with geomapping we get the zone each of this coordinates belongs to in terms of two classifications: original urban/rural areas and well-established NUTS3. So we have to run geocoding first to get the coordinates and then geomapping over geocoding's results.

## Geocoding

To know beforehand:

- Geocoding one single address takes little time, but it adds up when they are many.
- We have several tens of millions of applicants and inventors on our tables, but the number of different, unique addresses is much smaller.
- From our experience using geocoding and our knowledge of some addresses' quirks, we know that to get better results we must pre process the address fields' contents.

This immediately suggests geocoding every different address just once, and harmonizing and/or normalizing every address before doing so.

Before geocoding we have tables applt_addr and invt_addr, each one with a final_adr field.

There are 3 main steps to this enrichment.

1. Preparing for geocoding
   - We compile the unique addresses in a table and passed them through a home-made normalization function.
   - We use the resulting normalized addresses as an input for CorText's geocoding script.

2. Importing geocoding results
   - We need to be able to use the geolocation results produced for the addresses we prepared by CorText's geocoding script.

3. Organizing geocoding results
   - We have geolocation information for applicants and inventors in patstat thanks to CorText. This information, as well as existing address information, needs to be stored in a normalized manner or at least in a way that tries to avoid redundancy.

### Preparing Patstat addresses for geocoding
The [first step](./01_geocoding/00_prepare_addr.sql) is to prepare and store unique addresses from investors’ and applicants’ addresses which fall in our perimeter. We are focussing here on priority patents with artificial patents filed from 2000 (Laurens, P., Villard, L., Schoen, A. & Larédo, P., 2018, The artificial patents in the PATSTAT database: How much do they matter when computing indicators of internationalisation based on worldwide priority patents?. Scientometrics). 
This selection represents 2 394 385‬ distinct addresses. In order to increase the geocoding efficiency, addresses are going thought three cleaning steps:
   - Removing non alphanumerical characters (html codes, brackets, and some other special characters…): [normalise_specialChars](./01_geocoding/func_cleaning/normalise_specialChars.sql)
   - Normalising step: with first a basic transliteration and secondly a structure normalisation (e.g. space after comas or points): [normalise_specialChars](./01_geocoding/func_cleaning/norm_addr.sql)
   - Exclusions: finally, some meaningless values are excluded (e.g. deceased, verstorben etc.) when they do not contain geographical information.
93,7% of the submitted addresses have received longitude and latitude coordinates for the geocoding process.

### Importing geocoding results

We work with the db in which CorText keeps our dataset's information to add the relevant information to patstat. It is a sqlite database and what we need from it is the `geo_address` table, in which all fields added by the geocoding script are compiled along with the text used as input for each of the results. So, we must download the source db after geocoding and find a way to work with the `geo_address` table's contents.

There might be several ways to do this. We choose to export the `geo_address` table as a tab-separated file with all values enclosed by double-quotes and then load it into our lab schema in a suitable table. The ddl for this suitable table, the import command with its parameters and some useful index declarations can be found in [import_results](./01_geocoding/01_import_results.sql).

>Just like the addresses in our database; the number of different, unique geolocation results is much smaller than the number of addresses used as input. Knowing this, our aim will be to have each unique geolocation stored only once.

After running [import_results](./01_geocoding/01_import_results.sql) with its `load data` command pointing to the file we exported previously from our source db, a table called `geo_location_raw` is created and filled with `geo_address`'s contents.

`geo_location_raw`'s fields are:

| Field name  |     type     |                                            origin                                            |
| ----------- | ------------ | -------------------------------------------------------------------------------------------- |
| file        | text         | added by CorText                                                                             |
| id          | integer      | added by CorText to relate rows in a dataset                                                 |
| rank        | integer      | added by CorText                                                                             |
| address     | varchar(550) | text used as input for the geocoding script                                                  |
| label       | varchar(550) | geocoding result                                                                             |
| longitude   | double       | geocoding result                                                                             |
| latitude    | double       | geocoding result                                                                             |
| confidence  | double       | geocoding result                                                                             |
| accuracy    | varchar(20)  | geocoding result                                                                             |
| layer       | varchar(20)  | geocoding result                                                                             |
| city        | varchar(100) | geocoding result                                                                             |
| region      | varchar(100) | geocoding result                                                                             |
| country     | varchar(100) | geocoding result                                                                             |
| iso3        | varchar(3)   | geocoding result                                                                             |
| location_id | int(11)      | import leaves all null, used later to relate unique location to text addresses used as input |

This table works as a source of unique geolocations and as a means to relate a geolocation to an address via its `address` field.

It is important to notice that the fields marked as geocoding result in the previous table can be split in two groups according to the nature of the information they contain:
- purely associated with the **location**: label, longitude, latitude, city, region, country, iso3
- related to how the address used as an input is related to said location: confidence, accuracy, layer.

A **location** may appear several times in the results, with different values for the other fields. We can identify a unique geolocation using the 3-tuple formed by its label, longitude and latitude.

Based on these remarks, we decide to have all location-only information on its own table and to store the address-related fields produced by the script along with the addresses.

We intend to store every different result CorText gives us for all of our addresses in a new table, and we want to give them an identifier. The script [geo_location](./01_geocoding/02_01_geo_location.sql) creates the `geo_location` table and inserts on it every unique location found in `geo_location_raw`. `geo_location`:

| Field name  |     type     |
| ----------- | ------------ |
| location_id | int(11)      |
| label       | varchar(550) |
| longitude   | double       |
| latitude    | double       |
| city        | varchar(100) |
| region      | varchar(100) |
| country     | varchar(100) |
| iso3        | varchar(3)   |

With `location_id` being an auto-increment field, so that a unique identifier is given to each location while the table is filled up.

The script [update_geo_location](./01_geocoding/02_02_update_geo_location.sql) updates the `location_id` field in `geo_location_raw` to relate each row with its corresponding `geo_location`.

### Organizing geocoding results

We need to link the inventors and applicants information in patstat with the geolocation information we have. To summarize:

|      Table       |      field(s)       |                            remarks                             |
| ---------------- | ------------------- | -------------------------------------------------------------- |
| invt_addr        | adr_final           | original address text                                          |
| appln_addr       | adr_final           | original address text                                          |
| 04_addr_list     | adr_final           | same adr_final from invt_addr and appln_addr                   |
| 04_addr_list     | iso_ctry            | comes from original table                                      |
| 04_addr_list     | adr_final_norm_trim | adr_final after normalizing and trimming                       |
| geo_location_raw | geocoding results   | different ones are already compiled in `geo_location`          |
| geo_location_raw | location_id         | id of corresponding geo_location                               |
| geo_location_raw | address             | CorText input, same as adr_final_norm_trim from `04_addr_list` |
| geo_location     | geocoding results   | all unique locations in `geo_location_raw`                     |
| geo_location     | location_id         | unique id given to each different location                     |

We have all unique addresses in `04_addr_list` and we mentioned that some fields from CorText's results correspond to each address's relationship with the geolocation.

We decided to create a table `geo_addresses`, to be filled up with `04_addr_list` and `geo_location_raw`'s information. In this way, every unique address will have a unique id (`addr_id`), the `location_id`of its corresponding location, information about its relationship with it, and both original and normalized address texts. This is done in [geo_addresses](./01_geocoding/03_geo_addresses.sql). `geo_addresses` consists on:

|      field      |     type     |
| --------------- | ------------ |
| addr_id         | int(11)      |
| addr_final      | varchar(500) |
| addr_final_norm | varchar(500) |
| iso_ctry        | varchar(2)   |
| confidence      | double       |
| accuracy        | varchar(20)  |
| layer           | varchar(20)  |
| location_id     | int(11)      |

Now we have all unique addresses in `geo_addresses`, and those that have been geocoded have a value in their `location_id` field. What's left is to relate the original invt_addr and appln_addr tables with the new `geo_addresses` table. This is done in [propagate_to_bigger_tables]('./../01_geocoding/04_propagate_to_bigger_tables.sql') by adding an `addr_id` to both tables and updating it with `geo_addresses` using the original table's `adr_final` and `geo_addresses`'s `addr_final`.

## Geomapping

CorText's geomapping script takes a set of coordinates as input, and gives the zones they belong to in terms of several classifications. For patstat we want two of these classifications: urban/rural areas (ura) and NUTS3.

Our approach is as follows:
- Run the geomapping script over our geocoding results and import the resulting information.
- Store the zones' information we want in two new tables: `geo_nuts` and `geo_ura`, giving each zone an identifier.
- Relate our `geo_location` table with these two new tables.

### Importing NUTS3 and urban/rural areas

We have shapefiles for these, which can be easily exported to text files. We export them to a colon-separated csv file. Find the ddl and `load data` command with parameters for `geo_nuts` and `geo_ura` in [geo_nuts](./02_geomapping/00_geo_nuts.sql) and [geo_ura](./02_geomapping/00_geo_ura.sql) respectively. Notice we add the `nuts_id` and `ura_id` auto_increment fields as unique identifiers.

`geo_nuts`:

|   field    |     type     |
| ---------- | ------------ |
| nuts_id    | int(11)      |
| name       | varchar(200) |
| type       | varchar(50)  |
| ctrycodeis | varchar(3)   |
| nbcities   | int(11)      |
| sumpop     | int(11)      |
| source     | varchar(50)  |
| sourceid   | varchar(50)  |
| maincity   | varchar(50)  |
| sqkm       | double       |
| longitude  | double       |
| latitude   | double       |

`geo_ura`:

|   field    |     type     |
| ---------- | ------------ |
| ura_id     | int(11)      |
| name       | varchar(200) |
| type       | varchar(50)  |
| ctrycodeis | varchar(3)   |
| nbcities   | int(11)      |
| sumpop     | int(11)      |
| source     | varchar(50)  |
| sourceid   | varchar(50)  |
| sourcename | varchar(50)  |
| sqkm       | double       |
| longitude  | double       |
| latitude   | double       |

### Importing geomapping results

Like geocoding, in addition to producing some result files, geomapping also adds some new tables to the source db. We will use these tables' contents to relate `geo_location` to `geo_ura` and `geo_nuts`.

CorText geomapping uses the `longitude_latitude` table as an input and we are interested in the results stored in `map_id_nuts` and `map_id_ura`, these are all linked by an 'id' field. 

There are a few remarks about these tables:
- `longitude_latitude` contains coordinates in a 'longitude|latitude' format.
- `map_id_nuts` contains concatenations of the `source` and `sourceid` fields from the nuts zone.
- `map_id_ura` contains concatenations of the `source` and `sourceid` fields from the ura zone.
- this concatenation of `source` and `sourceid` unambiguously identifies a zone.
- `source` can contain spaces
- `sourceid` does not contain spaces

We export the three of them to tab-separated csv files, with each field enclosed by double-quotes.

We compile them in a single table called `tmp_geo_mapping`:

|     field     |    type     |
| ------------- | ----------- |
| id            | int(10)     |
| lon_lat       | varchar(50) |
| id_nuts       | varchar(50) |
| id_ura        | varchar(50) |
| longitude     | double      |
| latitude      | double      |
| source_nuts   | varchar(50) |
| sourceid_nuts | varchar(50) |
| source_ura    | varchar(50) |
| sourceid_ura  | varchar(50) |

We fill the `lon_lat`, `id_nuts` and `id_ura` fields by importing one by one the csv files into temporary tables and then updating `tmp_geo_mapping` using the `id` field.

The other fields are filled as follows:
- `longitude` and `latitude`: splitting `lon_lat` by '|'.
- `source_nuts` and `sourceid_nuts` splitting `id_nuts` by ' ' beginning from the end of the string.
- `source_ura` and `sourceid_ura` splitting `id_ura` by ' ' beginning from the end of the string.

So, after running [import_results](./02_geomapping/01_import_results.sql) we will have the information we need in `tmp_geo_mapping`.

### Linking results to `geo_location`

Both in `geo_location` and in `tmp_geo_mapping` we have sets of coordinates, and both in `tmp_geo_mapping` and in `geo_nuts` and `geo_ura` we have `source` and `sourceid`, so now we can use `tmp_geo_mapping` to link geolocations with the zones they were assigned by CorText geomapping.

This can be found in [add_to_geo_location](./02_geomapping/02_add_to_geo_location.sql). Our approach is as follows:

- Add indexes to `tmp_geo_mapping` and `geo_nuts` and `geo_ura` on (source, sourceid).
- Add fields `nuts_id` and `ura_id` to `tmp_geo_mapping`.
- Fill them using `source` and `sourceid` to find the zone in `geo_nuts` and `geo_ura`.
- Add fields `nuts_id` and `ura_id` to `geo_location`.
- Add indexes to `geo_location` and `tmp_geo_mapping` on longitude and latitude.
- Fill `nuts_id` and `ura_id` in `geo_location` using the coordinate pairs to find the coresponding row in `tmp_geo_mapping`. Note that for this step we grouped `tmp_geo_mapping` so that there is only one row per longitude, latitude pair and selected the rows where the relevant `id` (ura or nuts) is non-null.
- Delete `tmp_geo_mapping`


