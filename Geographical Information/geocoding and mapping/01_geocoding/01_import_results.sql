# ddl for pre geo table (address still there, not unique long, lat pairs)

drop table if exists geo_location_raw;
create table patstatAvr2017_lab.`geo_location_raw` (
  `file` text,
  `id` integer,
  `rank` integer,
  `address` varchar(550) character set utf8 collate utf8_unicode_ci default null,
  `label` varchar(550) character set utf8 collate utf8_unicode_ci default null,
  `longitude` double default null,
  `latitude` double default null,
  `confidence` double default null,
  `accuracy` varchar(20) character set utf8  collate utf8_unicode_ci default null,
  `layer` varchar(20) character set utf8  collate utf8_unicode_ci default null,
  `city` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `region` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `country` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `iso3` varchar(3) character set utf8 collate utf8_unicode_ci default null,
  `location_id` int(11) default null
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# load exported csv from sqlite into it

load data local infile
	'/home/luisd/tmp/geo_locations.csv'
into table patstatAvr2017_lab.geo_location_raw
character set utf8
fields terminated by "\t" enclosed by '"' # tab separated, every value is enclosed by ""
lines terminated by "\n" # standard, linebreaks mark the end of a row
ignore 1 lines # header is in the first row
(@file, @id, @rank, @address, @label, @longitude, @latitude, @confidence, @accuracy, @layer, @city, @region, @country, @iso3)
set
  file = nullif(@file,''),
  id = nullif(@id,''),
  rank = nullif(@rank,''),
  address = nullif(@address,''),
  label = nullif(@label,''),
  longitude = nullif(@longitude,''),
  latitude = nullif(@latitude,''),
  confidence = nullif(@confidence,''),
  accuracy = nullif(@accuracy,''),
  layer = nullif(@layer,''),
  city = nullif(@city,''),
  region = nullif(@region,''),
  country = nullif(@country,''),
  iso3 = nullif(@iso3,''); # 2 394 385

create index address_idx using btree on	geo_location_raw(address(300));
create index lon_lat_idx using btree on geo_location_raw(longitude, latitude);
