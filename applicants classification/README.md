# Classify Legal Entities And Individuals From Patent Applicants

## Goals

One of the main goal in our research group is the study and analysis in the behaivor of invetions and innovations made by legal entities, such as corporations, universities, research centers and in general every class of entity that do not fit into the “natural person” classification.

Considering this and always based on the data contributed by PATSTAT we started with a data restructuring to proceed on the classification effort, in this way we defined two entity class, legal and person. Thus, the present repository detail all the needed process to meet the objective.

Is important clarify that the number of stored applications on PATSTAT are more than 80 million and the number of applicants are near to 10 million, then, the execution for some of our functions normally might require a huge amount of time to be completed, of course that relate to the computer resource of each one.

## Classification of Entities

The initial assumption about how to get into the problem and solve it was through a small function with a big list of regular expressions that establish base on identifiers like “inc” “corp” etc wich determine if an applicant is a legal entity or not. But it was not so simple, for the fact, that a huge amount of companies does not have this kind of identifiers, like IBM. 

Then we try to turn the approach of the solution, instead of matching legals entities we wanted to identify the persons with three different methods, the first one was based on the structure of their names, the second one was with regular expression that matched cases when the applicant have Phd. or Dr. words and the third one is a dictionary of common names. But we found that a lot of companies have the same structure as a person name and even worse some companies were created with a persons name. So the solution was longer than we thought.

### Creating sets: probably legal, probably person and unkown.

With the previous experience we decided that before to run a regular expression method we are going to filter as much as possible each entity with a simpler processes. For that we will define 3 subsets, each one are composed by four columns: doc_std_name_id, doc_std_name, person_id and person_name. The first subset will be filled with unkown cases, the second with probably legal cases and the last one with probably person cases. 

To explain how we start to fill each set and how we will classify all entities, we divide the solution by steps, where each step contain their respective description with the total updated records.

It is important to know that all the methods were mainly based on the doc_std_name field, that field was created by PATSTAT and contain normalized name from the applicants, is not perfect, but we think is the best option since most of the public resources usually make reference to it.

#### Step 1 

We are going to query all the applicants that in some of their applications have the ownership of the patent and insert it into the “probl_legal” set. 

Is important to note that the total amount of applications are 82’448.209, but if we group by doc_std_name_id we have 9'961.212 total applicants.

Total records: **5'645.621**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img1.png">
</p>

#### Step 2

We query all the applicants that do not have any ownership patent and insert it into "unkown" set.

Total records: **4'315.591**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img2.png">
</p>

#### Step 3

From set "unkown" we take out all the applicants that have the source column from invt_addr_ifris different to “Missing” and we insert it into the "probable person" set.

Total records: **2'635.131**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img3.png">
</p>

#### Step 4

From set "unkown" we query all the applicants that have only one application and insert it into the "probable person" set.

Total records: **790.607**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img4.png">
</p>

#### Step 5

The applicants in set prob_legal that exist inside the invt_addr_ifris table and have less than 20 patent applications. We insert it into prob_person set.

Total records: **2.084.967**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img5.png">
</p>

#### Step 6

For this step we rely on the column person_name, although, this field is more messy than the doc_std_name it has some additional information related to the natural person structure that helped us to create a further filter. For this we are going to take off from prob_legal set the records that have a structure similar to __, __ and less than 200 patent applications. 

Total records: **167.869**

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img6.png">
</p>

#### Step 7 

Another point to consider is the percentage of the patents where the applicant has the ownership. For this we created a new table called “temporal” where we insert all the applicants that on their applications have less of 80 percents of the ownership, to later delete these applicants from set "prob_legal" and insert them into "prob_person".

<p align="center">
<img src="https://raw.githubusercontent.com/cortext/patstat/master/applicants%20classification/img/img7.png">
</p>

### Firms identifiers REGEX

At this point we have a clear view of the entity's classification, therefore is easier for us to do a data analysis and execute the initial process we had in mind. Thus, we created a function to check over a regular expression list if a record is a firm or not from some common identifier,those were built based on magerman list and "the patent name-matching project" by Berkley, the function file can be found in the repository named firm_detection.sql 

The previous function was executed on the sets prob_person and prob_legal in order to mark certainly the legal entities and the natural persons, at the end we have the following results:

* Total records: **53.813** (Firms detected from prob_person)

* Total records: **2’109.217** (Firms detected from prob_legal)

Then we detected 2'109.217 firms. Now The tables prob_person and prob_legal are cleaner. The next was built a sample with more than 3000 records from each datasets (prob_person and prob_legal), we analyze them and detected that inside prob_person there were still some companies with common identifiers such as "the", "of" etc. Therefore we build another list with firms identifiers that's covered this kind of cases, you can find the list [here](http://www.riainabox.com/blog/the-top-50-most-commonly-used-words-in-ria-firm-names). We insert the result inside "Legal" table.

* Total records: **4.863**

### Cleaning Ambiguous Cases

Now we have 1’630.287 records from the table prob_legal, which we called ambiguous cases, because by the analysis done previously over the sample, determined that approximately 70% of those are natural persons and many companies over there seems natural persons too, but actually are firms with people names. So we need to cleaning up even more the datasets, for this we perform the following steps.

#### Countries, ISO country code and Capitals

A lot of the firm's records from ambiguous cases are composed by country names, ISO country code or capital names, that's why we build and run a function with a list of all countries, ISO codes and capitals.

* Total detected ISO Country code: **53176**

* Total detected Capitals: **4573**

* Total detected by Country: **62.384**

* Total Records: **120.133**

#### New firm detection Regex

Another analysis was made over the ambiguous records and we realized that a lot of them have some incomplete identifier or a new identifier that give us the opportunity to create a completely new function, the final result was a list of 453 new cases, additionally in this step we executed a script to detect records that are composed only by one word like ‘IBM’. We executed it and the result is the next. (The function file is second_firm_detect.sql)

* Total records: **393.391**


#### Common applicants names

From the applicants table we builded a list of the most common names that were find there. The records detected by the list 
were inserted inside prob_person table and the list is named "individuals.sql".

* Total records: **1.123**

#### Common Surnames and Names

Now we have a set with a total number of 1.128.134 ambiguous records, this is a higher figure than the 70 percent mentioned above. Our priority is to identify the largest amount of legal entities, for this reason, we continue with the cleaning and filtering process, for this we detected natural persons with a list created by ourselves that contains the most common surnames and names of the top 20 countries by number of patents, the list of countries is:

Japan
Usa
China
South korea
Germany
France
United Kingdom
Russia
Switzerland
Netherlands
Italy
Canada
Sweden
Australia
Finland
Israel
Spain
Denmark
Austria
Belgum

At the end we have two list, one with 3161 lastnames and the other one with 5494 names. Both were builded based on [url](https://www.behindthename.com/top/lists/belgium/2015) for surnames and [here](http://www.studentsoftheworld.info/penpals/stats.php3?Pays=JAP) for the most common names. We the result records we created a set called "ambiguous_person" 

* Total detected by surnames list: **459.634**

* Total detected by names list: **264.794**

* Total Records: **724.428**

#### Name and Firms Pattern

We identified another pattern to filter natural persons, this is when a name have three words and a comma inside the person_name column, we insert the returned records into prob_person set. Also for firms, we determined when the doc_std_name is composed of one word or by more than 4 words, then we insert those into the "legal" set.

* Total Records: **6.420**

#### Final Firms Identifiers

Once again we've filled the prob_person set, thus, we analyzed it and realized that left some identifiers to detect firms, for these identifiers we simply created a list with like clause.

* Total Records: **1.938**

#### Regex for person_name column

Continuing with the prob_person set, we establish like firms the records that are detected by the regex functions, but instead run it over doc_std_name column we used person_name column.

* Total Records: **3.546**

#### Most important Firms

## Quality checks
add here all the quality checks (Phil + Pat)

## Conclusions



