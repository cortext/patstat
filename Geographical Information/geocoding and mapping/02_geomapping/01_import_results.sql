# ddl for geomapping results

drop table if exists patstatAvr2017_lab.tmp_geo_mapping;
create table patstatAvr2017_lab.tmp_geo_mapping (
	`id` int(10),
	`lon_lat` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`id_nuts` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`id_ura` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`longitude` double default null,
	`latitude` double default null,
	`source_nuts` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`sourceid_nuts` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`source_ura` varchar(50) character set utf8 collate utf8_unicode_ci default null,
	`sourceid_ura` varchar(50) character set utf8 collate utf8_unicode_ci default null,	
	primary key (id)
) engine=MyISAM default charset=utf8 collate=utf8_unicode_ci;

# Any field first, in this case addr

load data local infile
	'/home/luisd/tmp/addr_list_v02/lon_lat.csv'
into table patstatAvr2017_lab.tmp_geo_mapping
character set utf8
fields terminated by "\t" enclosed by '"' # tab separated, every value is enclosed by ""
lines terminated by "\n" # standard, linebreaks mark the end of a row
ignore 1 lines # header is in the first row
(@file, @id, @rank, @parserank, @data)
set
  id = nullif(@id,''),
  lon_lat = nullif(@data,'');
  
# Add the other fields

drop table if exists patstatAvr2017_lab.tmp_geo_nuts;
create table patstatAvr2017_lab.tmp_geo_nuts like patstatAvr2017_lab.tmp_geo_mapping;
load data local infile
	'/home/luisd/tmp/addr_list_v02/map_id_nuts.csv'
into table patstatAvr2017_lab.tmp_geo_nuts
character set utf8
fields terminated by "\t" enclosed by '"' # tab separated, every value is enclosed by ""
lines terminated by "\n" # standard, linebreaks mark the end of a row
ignore 1 lines # header is in the first row
(@id, @file, @rank, @parserank, @data)
set
  id = nullif(@id,''),
  id_nuts = nullif(@data,'');
update
	patstatAvr2017_lab.tmp_geo_mapping main
	inner join
	patstatAvr2017_lab.tmp_geo_nuts other
	on main.id = other.id
set main.id_nuts = other.id_nuts;
drop table patstatAvr2017_lab.tmp_geo_nuts;

drop table if exists patstatAvr2017_lab.tmp_geo_ura;
create table patstatAvr2017_lab.tmp_geo_ura like patstatAvr2017_lab.tmp_geo_mapping;
load data local infile
	'/home/luisd/tmp/addr_list_v02/map_id_ura.csv'
into table patstatAvr2017_lab.tmp_geo_ura
character set utf8
fields terminated by "\t" enclosed by '"' # tab separated, every value is enclosed by ""
lines terminated by "\n" # standard, linebreaks mark the end of a row
ignore 1 lines # header is in the first row
(@id, @file, @rank, @parserank, @data)
set
  id = nullif(@id,''),
  id_ura = nullif(@data,'');
update
	patstatAvr2017_lab.tmp_geo_mapping main
	inner join
	patstatAvr2017_lab.tmp_geo_ura other
	on main.id = other.id
set main.id_ura = other.id_ura;
drop table patstatAvr2017_lab.tmp_geo_ura;

# Split coordinates, nuts and ura ids

update patstatAvr2017_lab.tmp_geo_mapping
set
	longitude = case when lon_lat = "|" then null else substring_index(lon_lat, '|', 1) end,
	latitude = case when lon_lat = "|" then null else substring_index(lon_lat, '|', -1) end,
	sourceid_nuts = substring(id_nuts, length(id_nuts) - instr(reverse(id_nuts), ' ') + 2, length(id_nuts)), # First from right to left
	source_nuts = substring(id_nuts, 1, length(id_nuts) - instr(reverse(id_nuts), ' ')), # The rest from right to left
	sourceid_ura = substring(id_ura, length(id_ura) - instr(reverse(id_ura), ' ') + 2, length(id_ura)), # First from right to left
	source_ura = substring(id_ura, 1, length(id_ura) - instr(reverse(id_ura), ' ')); # The rest from right to left








