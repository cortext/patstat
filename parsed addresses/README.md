# Enriching Patstat: Parsing the addresses from person_name field

Patstat store the information of more than 60 millions of patent applicants, either natural persons or legal entities, most of these these information can be consulted in the table tls206_person. Nevertheless, almost in half of the record the address information is missing, but doing an analysis of those cases wherein the address field was empty, it was determined that in a few cases the addresses is concatenated into the field person_name.
