# ddl for geo_nuts

drop table if exists patstatAvr2017_lab.`geo_nuts`;
CREATE TABLE patstatAvr2017_lab.`geo_nuts` (
  `nuts_id` int(11) not null auto_increment,
  `name` varchar(200) character set utf8 collate utf8_unicode_ci default null,
  `type` varchar(50) character set utf8 collate utf8_unicode_ci default null,
  `ctrycodeis` varchar(3) character set utf8 collate utf8_unicode_ci default null,
  `nbcities` int(11) default null,
  `sumpop` int(11) default null,
  `source` varchar(50) character set utf8 collate utf8_unicode_ci default null,
  `sourceid` varchar(50) character set utf8 collate utf8_unicode_ci default null,
  `maincity` varchar(50) character set utf8 collate utf8_unicode_ci default null,
  `sqkm` double default null,
  `longitude` double default null,
  `latitude` double default null,
  primary key (nuts_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

# load from txt file exported from shapefile

load data local infile
	'/home/luisd/tmp/nut3_classification_201910.txt'
into table patstatAvr2017_lab.geo_nuts
character set utf8
fields terminated by ";" optionally enclosed by '"' # ; separated, not every value is enclosed by ""
lines terminated by "\n" # standard, linebreaks mark the end of a row
ignore 1 lines # header is in the first row
(@FID, @name, @type, @ctrycodeis, @nbcities, @sumpop, @source, @sourceid, @maincity, @sqkm, @longitude, @latitude, @uniqueid)
set
    name = nullif(@name, ''),
    type = nullif(@type, ''),
    ctrycodeis = nullif(@ctrycodeis, ''),
    nbcities = nullif(replace(@nbcities, ',', ''), ''), # Has thousands separators in the original file
    sumpop = nullif(replace(@sumpop, ',', ''), ''), # Has thousands separators in the original file
    source = nullif(@source, ''),
    sourceid = nullif(@sourceid, ''),
    maincity = nullif(@maincity, ''),
    sqkm = nullif(replace(@sqkm, ',', ''), ''), # Has thousands separators in the original file
    longitude = nullif(@longitude, ''),
    latitude = nullif(@latitude, '');
   





