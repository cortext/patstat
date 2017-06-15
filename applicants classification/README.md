# Classify Legal Entities And Individuals From Patent Applicants

## Goals

One of the main goal in our research group is the study and analysis in the behaivor of invetions and innovations made by legal entities, such as corporations, universities, research centers and in general every class of entity that do not fit into the “natural person” classification.

Considering this and always based on the data contributed by PATSTAT we started with a data restructuring to proceed on the classification effort, in this way we defined two entity class, legal and person. Thus, the present repository detail all the needed process to meet the objective.

Is important clarify that the number of stored applications on PATSTAT are more than 80 million and the number of applicants are near to 10 million, then, the execution for some of our functions normally might require a huge amount of time to be completed, of course that relate to the computer resource of each one.

## Classification of Entities

The initial assumption about how to get into the problem and solve it was through a small function with a big list of regular expressions that establish a base on identifiers like “inc” “corp” etc wich determine if an applicant is a legal entity or not. But it was not so simple, for the fact, that a huge amount of companies does not have this kind of identifiers, like IBM. 

Then we try to turn the approach of the solution, instead of matching legals entities we wanted to identify the persons with three different methods, the first one was based on the structure of their names, the second one was with regular expression that matched cases when the applicant have Phd. or Dr. words and the third one is a dictionary of common names. But we found that a lot of companies have the same structure as a person name and even worse some companies were created with a persons name. So the solution was longer than we thought.

### Creating sets: probably legal, probably person and unkown.

With the previous experience we decided that before to run a regular expression method we are going to filter as much as possible each entity with a simpler processes. For that we will define 3 subsets, each one are composed by four columns: doc_std_name_id, doc_std_name, person_id and person_name. The first subset will be filled with unkown cases, the second with probably legal cases and the last one with probably person cases. 

To explain how we start to fill each set and how we will classify all entities, we divide the solution by steps, where each step contain their respective description with the total updated records.

It is important to know that all the methods were mainly based on the doc_std_name field, that field was created by PATSTAT and contain normalized name from the applicants, is not perfect, but we think is the best option since most of the public resources usually make reference to it.

#### Step 1 

We are going to query all the applicants that in some of their applications have the ownership of the patent and insert it into the “probl_legal” set. 

Is important to note that the total amount of applications are 82’448.209, but if we group by doc_std_name_id we have 9'961.212 total applicants.

Total records: **5’645.621**


