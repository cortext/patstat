# Patstat
A bunch of amazing scripts, mainly in SQL, made by members of platform CorText to build up and enriche Patstat relational database (EPO).

## Basic description of patstat
The PATSTAT database has become the main patent data source for academics using patent data as for statistics users and producers all over the world (for OECD and Eurostat in particular). PATSTAT, which proposes a complete coverage of patenting activities from more than 170 patent offices (and oldest patent documents date from the end of the 19th century), is a valuable tool for the community of researchers because it contains raw data that is collected in a transparent manner. With more than 70 million of patents, this rich database has contributed to greatly improve the quality of empirical research in the field of technometrics. 

But despite the detailed methodological guidance provided by its producers and by several academic forums, the set up of the database still requires the competencies of a database specialist. Furthermore, the implementation of standard improvements, even when using freely available complementary resources (e.g. REGPAT, proposed by the OECD), necessitates additional resources that can be beyond the reach of academic teams.

Building on competencies accumulated over the years and mobilising dedicated resources, IFRIS UPEM, as a research centre specialised in quantitative STI, has incorporated in the PATSTAT-IFRIS database a series of improvements, stemming from outside providers (OECD) or from its own proprietary developments.

## What is Patstat-IFRIS 
PATSTAT-IFRIS is a patent database that has been set up using the European Patent Office (EPO) Worldwide Patent Statistical Database, henceforth PATSTAT developed by the European Patent Office. The conceptual model of the database offers the ability to manipulate relations between more than 30 tables. Each table contains a set of variables that enable studying several analytical dimensions: contents (title, abstract...), knowledge dynamics (bibliographical links for science and technology, fine grained description of the technological fields...), organisation (intellectual property through applicant names), geography (localisation of the inventions and collaborations)...

But PATSTAT-IFRIS is as well an augmented version of the generic PATSTAT database in the sense that it includes a series of enrichment thanks to the filling of information missing in the initial PATSTAT database (e.g: addresses), the harmonisation of raw information from the initial PATSTAT database (e.g: country information) and the addition of new information (e.g: technological classification).

## Patstat-IFRIS highlights

With ten years of accumulation of scripts and methods, we have been used different versions of the database:
* Patstat 2008; 
* Patstat 2009;
* Patstat 2011;
* Patstat 2014, april (production database).
The scripts and methods that are presented here are made for the last version.

The emphasis has been put on three long term kind of enrichments:
* New variables: inside tables, something with a cleaning step, to make the production of statistics easier; 
* Enrichments: new values from external sources or from an internal propagations (e.g. addresses...);
* New analytical dimensions: completely new tables to make your analysis richer (e.g. technologies...).
