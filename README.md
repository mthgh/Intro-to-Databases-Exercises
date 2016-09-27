# Intro to Databases Exercise
This include exercises and materials from [Introduction to Databases](https://lagunita.stanford.edu/courses/Engineering/db/2014_1/about) offered by stanford.
##1. Relational Algebra Exercises
Relational Algebra exercises Q&A was in the "Relational Algebra" folder.

To check the query result:  
(1) Open command line, navigate to "...\utils\ra" where the "ra.jar" locates, run 'java -jar ra.jar -i "..\\..\Relational Algebra\sample.ra"' to populate the database. You should be able to see several update information.     
(2) Run 'java -jar ra.jar -i "..\\..\Relational Algebra\exercise.ra"' and 'java -jar ra.jar -i "..\\..\Relational Algebra\extra_problems.ra"' to see the query result from exercise and extra-problems respectively.

There is also a pdf file inside "utils\ra", it is part of the course materials and describes how to install a RA relational algebra interpreter.
##2. SQL Exercises
SQL exercises Q&A could be find in the "sql" folder. This include database querying, database modification, constrains creation, triggers creation, views creation, views modification, OLAP querying and recursive querying for several different databases. In each database sub-folder, there is a sql file used for populating the data (containing the schema and original data to insert), and several other querying/modification Q&A files.

To run the queries, follow the pdf guide "Quick Guide to SQLite, MySQL, and PostgreSQL" inside "utils" folder to install mysql, sqlite and postgresql. The guide was downloaded from the course materials. Specifically, since sql syntax is a little bit different for the three systems. In my exercises, except recursive-exercise which was queried against postgresql and OLAP-exercise which was queried against mysql, all other exercises were queried using sqlite.

##3. XML Exercises
XML DTD validation exercises were in folder "xml-validation". This folder contains xml data and respective dtd validation files.    
To check the validation result, run "xml_validation.py" inside "utils" folder.

XML querying Q&A were in folder "xml-query". This folder include XSLT, Xpath and XQuery for two databases. The respective xml data and queries could be find in each database sub-folder.   
"Kernow" was used to run the queries and check result. "Kernow" could be find inside "utils\xml_query\Kernow 1.8.0.1", follow "kernow_readme.txt" to run kernow and xml queries (need to copy all data and query files from sub-folder of "xml-query" to "utils\xml_query\Kernow 1.8.0.1"). A pdf guide to download and use kernow was avalible from "utils\xml_query", this pdf file is a part of the course materials.


