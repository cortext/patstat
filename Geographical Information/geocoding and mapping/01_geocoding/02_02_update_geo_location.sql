update
	geo_location_raw big,
	geo_location small
set
	big.location_id = small.location_id
where
	big.longitude = small.longitude
and big.latitude = small.latitude
and big.label = small.label;
