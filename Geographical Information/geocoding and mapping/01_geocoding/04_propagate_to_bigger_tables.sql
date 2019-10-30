# Propagate to bigger tables

# Add address id

alter table patstatAvr2017.applt_addr_ifris add addr_id int(11);
alter table patstatAvr2017.invt_addr_ifris add addr_id int(11);

# bring values from geo_addresses

update
	patstatAvr2017.applt_addr_ifris applt
	inner join
	patstatAvr2017_lab.geo_addresses addr
	on applt.adr_final = addr.addr_final
set
	applt.addr_id = addr.addr_id;

update
	patstatAvr2017.invt_addr_ifris invt
	inner join
	patstatAvr2017_lab.geo_addresses addr
	on invt.adr_final = addr.addr_final
set
	invt.addr_id = addr.addr_id;
	
select * from patstatAvr2017.invt_addr_ifris;