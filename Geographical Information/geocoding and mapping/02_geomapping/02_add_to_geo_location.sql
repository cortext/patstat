# add nuts_id and ura_id to tmp_geo_mapping

# create indexes

create index nuts_source_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(source_nuts, sourceid_nuts);
create index ura_source_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(source_ura, sourceid_ura);
create index source_idx using btree on patstatAvr2017_lab.geo_nuts(source, sourceid);
create index source_idx using btree on patstatAvr2017_lab.geo_ura(source, sourceid);

# add keys to tmp_geo_mapping

alter table patstatAvr2017_lab.tmp_geo_mapping add `nuts_id` int(11) default null;
alter table patstatAvr2017_lab.tmp_geo_mapping add `ura_id` int(11) default null;

update
	patstatAvr2017_lab.tmp_geo_mapping gm
	inner join
	patstatAvr2017_lab.geo_nuts nuts
	on
	gm.source_nuts = nuts.source and gm.sourceid_nuts = nuts.sourceid
set
	gm.nuts_id = nuts.nuts_id; # 1 170 384

update
	patstatAvr2017_lab.tmp_geo_mapping gm
	inner join
	patstatAvr2017_lab.geo_ura ura
	on
	gm.source_ura = ura.source and gm.sourceid_ura = ura.sourceid
set
	gm.ura_id = ura.ura_id; # 2 215 537

# add keys to geo location
	
alter table patstatAvr2017_lab.geo_location add `nuts_id` int(11) default null;
alter table patstatAvr2017_lab.geo_location add `ura_id` int(11) default null;

# update using tmp_geo_mapping

# create long_lat indexes

create index lon_idx using btree on patstatAvr2017_lab.geo_location(longitude);
create index lat_idx using btree on patstatAvr2017_lab.geo_location(latitude);

create index lon_lat_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(longitude, latitude);
create index lon_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(longitude);
create index lat_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(latitude);

# create key indexes
create index nuts_id_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(nuts_id);
create index ura_id_idx using btree on patstatAvr2017_lab.tmp_geo_mapping(ura_id);

update
	patstatAvr2017_lab.geo_location loc
	inner join
	(select * from (select * from patstatAvr2017_lab.tmp_geo_mapping clas group by longitude, latitude) a where a.ura_id is not null) clas
	on
	loc.longitude = clas.longitude and loc.latitude = clas.latitude
set loc.ura_id = clas.ura_id; # 315 628
	
update
	patstatAvr2017_lab.geo_location loc
	inner join
	(select * from (select * from patstatAvr2017_lab.tmp_geo_mapping clas group by longitude, latitude) a where a.nuts_id is not null) clas
	on
	loc.longitude = clas.longitude and loc.latitude = clas.latitude
set loc.nuts_id = clas.nuts_id; # 147 166

drop table patstatAvr2017_lab.tmp_geo_mapping;

# Done!

select loc.label, loc.region, loc.country, nuts.name, nuts.ctrycodeis
from patstatAvr2017_lab.geo_location loc 
	 inner join 
	 patstatAvr2017_lab.geo_nuts nuts
	 on loc.nuts_id = nuts.nuts_id;

select loc.label, loc.region, loc.country, ura.name, ura.type, ura.ctrycodeis
from patstatAvr2017_lab.geo_location loc
	 inner join patstatAvr2017_lab.geo_ura ura 
	 on loc.ura_id = ura.ura_id;




