-- ddl for new geo table

drop table if exists patstatAvr2017_lab.`geo_location`;
CREATE TABLE patstatAvr2017_lab.`geo_location` (
  `location_id` int(11) not null auto_increment,
  `label` varchar(550) character set utf8 collate utf8_unicode_ci default null,
  `longitude` double default null,
  `latitude` double default null,
  `city` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `region` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `country` varchar(100) character set utf8 collate utf8_unicode_ci default null,
  `iso3` varchar(3) character set utf8 collate utf8_unicode_ci default null,
  primary key (location_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- insert the unique ones

insert into geo_location(label, longitude, latitude, city, region, country, iso3)
select 
	label, longitude, latitude, city, region, country, iso3
from geo_location_raw where latitude is not null group by longitude, latitude, label; # 315 628

-- indexes

create index long_lat_idx using	btree on geo_location(longitude, latitude);
create index label_idx using btree on geo_location(label(300));
create index layer_idx using btree on geo_location(layer);
create index city_idx using btree on geo_location(city);
create index region_idx using btree on geo_location(region);
create index country_idx using btree on geo_location(country);
create index iso3_idx using btree on geo_location(iso3);




