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

### Firms identifiers REGEX

At this point we have a clear view of the entity's classification, therefore is easier for us to do a data analysis and execute the initial process we had in mind. Thus, we created a function to check over a regular expression list if a record is a firm or not from some common identifier,those were built based on magerman list and "the patent name-matching project" by Berkley, the function file can be found in the repository named firm_detection.sql 

The previous function was executed on the sets prob_person and prob_legal in order to mark certainly the legal entities and the natural persons, at the end we have the following results:

**53.813** Firms detected from prob_person

**2’109.217** Firms detected from prob_legal

Then we detected 2'109.217 firms. Now The tables prob_person and prob_legal are cleaner. The next was built a sample with more than 3000 records from each datasets (prob_person and prob_legal), we analyze them and detected that inside prob_person there were still some companies with common identifiers such as "the", "of" etc. Therefore we build another list with firms identifiers that's covered this kind of cases, you can find the list here. We insert the result inside "Legal" table.

**4.863** Matched

### Cleaning Ambiguous Cases
