# Classifying Legal Entities And Individuals From Patent Applicants

## Introduction

One of the main goals in our research activities is the study and analysis on the dynamics of R&D and innovations made by legal entities, such as corporations, universities, research centers and in general every class of entity that do not fit into the categorization of “natural person”. Considering the above, we have worked with the data contributed by PATSTAT to start with the data restructuring in order to begin on the classification process, in this way we have defined two entities classes, legal and person. Thus, the present repository detail the required process to achieve that objective.

Is important to clarify that the number of applications stored on PATSTAT are more than 80 million and the number of applicants are nearly 10 million, hence, the execution for some of the functions presented in this repository usually should require a huge amount of time to be complete, of course, that is related to the computational resources of each one.

## Classification of entities 

In the entities that can be found within the patstat applicants coexist a large proportion of homonym names, for instance, the word 'Ford' may be tagged as a company or as an individual, which means that, using a direct approach of detection where several functions that implement gazetteers and by combing regular expressions could lead in a low quality results for the categorization of legal entities and individuals.

Therefore, we turn the approach of the solution, instead of merely doing a direct match we used an heuristic approach in the patent context in order to separate the different entities into three subsets named as 'probably legal', 'probably individual' and 'ambiguous'. The allocation of each entity is designated by a series of methods and rules that are relay on not only on the used of gaztteers but on the characterization of the applicants through the relation with the patent, besides some simple lexical identifiers.

### Creating sets: probably legal, probably person and unkown.



