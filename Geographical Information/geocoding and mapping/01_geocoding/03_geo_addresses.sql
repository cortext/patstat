-- ddl for new address table

drop table if exists patstatAvr2017_lab.geo_addresses;

create table patstatAvr2017_lab.geo_addresses (
  `addr_id` int(11) not null auto_increment,
  `addr_final` varchar(500) character set utf8 collate utf8_unicode_ci not null,
  `addr_final_norm` varchar(500) character set utf8 collate utf8_unicode_ci not null,
  `iso_ctry` varchar(2) collate utf8_unicode_ci not null default '',
  `confidence` double default null,
  `accuracy` varchar(20) character set utf8  collate utf8_unicode_ci default null,
  `layer` varchar(20) character set utf8  collate utf8_unicode_ci default null,
  `location_id` int(11) default null,
  primary key (addr_id),
  key `addr_idx` (`addr_final`(300)),
  key `addr_norm_idx` (`addr_final_norm`(300)),
  key `addr_norm_trim_idx` (`addr_final_norm_trim`(300)),
  key `iso_ctry_idx` (`iso_ctry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- copy its content from previous address table

insert into patstatAvr2017_lab.geo_addresses(addr_final, addr_final_norm, iso_ctry)
select
	adr_final, adr_final_norm_trim as addr_final_norm, iso_ctry
from
	patstatAvr2017_lab.04_addr_list; # 7 635 653

-- from raw address table to geo_addresses using the addr_harm field (trimmed)

select count(*) from geo_addresses; # 7 635 653
select count(*) from geo_location_raw; # 2 394 385

update
	geo_addresses big
	inner join
	geo_location_raw small
on
	big.addr_final_norm_trim = small.address
set
	big.location_id = small.location_id,
	big.confidence = small.confidence,
	big.accuracy = small.accuracy,
	big.layer = small.layer; # 2 447 106

