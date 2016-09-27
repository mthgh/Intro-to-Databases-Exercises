/* You will perform "on-line analytical processing" (OLAP) style queries over 
a simple "star schema" containing information about students, instructors, 
classes, and students taking classes from instructors. A SQL file to set up 
the schema and data for these exercises is "classes.sql". This schema and data 
can be loaded as specified in the file into SQLite, MySQL, or PostgreSQL. 
Queries 1-5 can be solved on any of the three systems, but currently only 
MySQL supports the "WITH ROLLUP" construct needed for queries 6-12. See our quick 
guide for installing and using the three systems.

Schema:
Student( studID, name, major )   // dimension table, studID is key
Instructor( instID, dept );   // dimension table, instID is key
Class( classID, univ, region, country );   // dimension table, classID is key
Took( studID, instID, classID, score );   // fact table, foreign key references 
                                             to dimension tables

As a guide to test the accuracy of your SQL queries, the correct query results 
over the provided data can be seen by pressing the button at the bottom of the page.


/* Q1.Find all students who took a class in California from an instructor not in 
the student's major department and got a score over 80. Return the student name, 
university, and score. */
select name, univ, score
from student S, instructor I, class C, took T
where s.studID=t.studID and I.instID=T.instID and T.classID=C.classID
and score>80 and region="CA" and major<>dept;

/* Q2. Find average scores grouped by student and instructor for courses taught in 
Quebec.*/
select studID, instID, avg(score)
from Took
where classID in (select classID from Class where region="Quebec")
group by instID, studID;

/* Q3. "Roll up" your result from problem 2 so it's grouping by instructor only.*/
select instID, avg(score)
from Took
where classID in (select classID from Class where region="Quebec")
group by instID;

/* Q4. Find average scores grouped by student major.*/
select major, avg(score)
from Student S, Took T
where s.studID=t.studID
group by major;

/* Q5. "Drill down" on your result from problem 4 so it's grouping by instructor's 
department as well as student's major.*/
select dept, major, avg(score)
from Student S, Took T, instructor I
where s.studID=t.studID and I.instID=t.instID
group by dept, major;

/*Q6. Use "WITH ROLLUP" on attributes of table Class to get average scores for all 
geographical granularities: by country, region, and university, as well as the overall 
average.*/
select country, region, univ, avg(score)
from class c, took t
where c.classID=t.classID
group by country, region, univ with rollup;

/*Q7. Create a table containing the result of your query from problem 6. Then use 
the table to determine by how much students from USA outperform students from Canada in 
their average score.*/
create table region_avg_score as
select country, region, univ, avg(score) as ave_score
from class c, took t
where c.classID=t.classID
group by country, region, univ with rollup;

select distinct
(select ave_score
from region_avg_score
where country="USA" and region is null and univ is null)
-
(select ave_score
from region_avg_score
where country="Canada" and region is null and univ is null)
from region_avg_score;

/*Q8. Verify your result for problem 7 by writing the same query over the original tables 
without using "WITH ROLLUP".*/
select distinct
(select avg(score)
from class, took
where class.classID=took.classID and country="USA")
-
(select avg(score)
from class, took
where class.classID=took.classID and country="Canada")
from took;

/*Q9. Create the following table that simulates the unsupported "WITH CUBE" operator.*/
  create table Cube as
  select studID, instID, classID, avg(score) as s from Took
  group by studID, instID, classID with rollup
  union
  select studID, instID, classID, avg(score) as s from Took
  group by instID, classID, studID with rollup
  union
  select studID, instID, classID, avg(score) as s from Took
  group by classID, studID, instID with rollup;
  
 /*Using table Cube instead of table Took, and taking advantage of the special tuples with 
 NULLs, find the average score of CS major students taking a course at MIT. */ 
  select avg(s)
  from
  (select c.classID, c.studID, s
  from cube c, class cl, student s
  where c.studID=s.studID and c.classID=cl.classID and major="CS"
  and univ="MIT" and instID is null) B;
  
/*Q10. Verify your result for problem 9 by writing the same query over the original tables.*/
  select avg(score)
  from class c, student s, took t
  where s.studID=t.studID and c.classID=t.classID
  and major="CS" and univ="MIT";

/*11. Whoops! Did you get a different answer for problem 10 than you got for problem 9? What went 
wrong? Assuming the answer on the original tables is correct, create a slightly different data 
cube that allows you to get the correct answer using the special NULL tuples in the cube. 
Hint: Change what dependent value(s) you store in the cells of the cube; no change to the 
overall structure of the query or the cube is needed.*/
  create table cube1 as
  select studID, count(instID) as num, instID, classID, avg(score) as s from Took
  group by studID, instID, classID with rollup
  union
  select studID, count(instID) as num, instID, classID, avg(score) as s from Took
  group by instID, classID, studID with rollup
  union
  select studID, count(instID) as num, instID, classID, avg(score) as s from Took
  group by classID, studID, instID with rollup;
  
  select sum(s*num)/sum(num)
  from
  (select c.*
  from cube1 c, class cl, student s
  where c.studID=s.studID and c.classID=cl.classID and major="CS"
  and univ="MIT" and instID is null) B;
  
/*Q12. Continuing with your revised cube from problem 11, compute the same value but this time don't 
use the NULL tuples (but don't use table Took either). Hint: The syntactic change is very small and 
of course the answer should not change.*/
  select sum(s*num)/sum(num)
  from
  (select c.*
  from cube1 c, class cl, student s
  where c.studID=s.studID and c.classID=cl.classID and major="CS"
  and univ="MIT" and instID is not null) B;
  