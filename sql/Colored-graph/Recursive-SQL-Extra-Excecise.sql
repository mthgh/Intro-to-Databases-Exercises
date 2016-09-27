/* You're tasked with performing graph analyses using a relational database 
system. You quickly recognize that recursion is needed to analyze arbitrary 
graphs using SQL queries. Fortunately, recursive SQL is available in some 
systems. In these exercises, you'll develop queries on a small graph with 
colored nodes and weighted edges. A SQL file to set up the schema and data 
for these exercises is "colored-graph.sql" here. This schema and data can be loaded 
as specified in the file into SQLite, MySQL, or PostgreSQL, but currently only 
PostgreSQL supports recursion. See our quick guide for installing and using PostgreSQL.

Schema:
Node ( nID, color )
Edge ( n1, n2, weight )  // n1 and n2 identify nID's in table Node

As a guide to test the accuracy of your SQL queries, the correct query results over 
the provided data can be seen by pressing the button at the bottom of the page. 
You can return results in any order, but you may find it convenient to sort them in
order to compare your results against the correct ones.*/



/*Q1. Find all node pairs n1,n2 that are both red and there's a path of length one 
or more from n1 to n2.*/
WITH recursive
PATH AS (SELECT N1, N2 FROM EDGE
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1)
SELECT n1, n2 
FROM path 
WHERE n1 IN (SELECT nID FROM node WHERE color='red')
AND n2 IN (SELECT nID FROM node WHERE color='red');


/*Q2. If your solution to problem 1 first generates all node pairs with a path between 
them and then selects the red pairs, formulate a more efficient query that incorporates 
"red" into the recursively-defined relation in some fashion.*/
WITH recursive
PATH AS (SELECT N1, N2 FROM EDGE
         WHERE n1 IN (SELECT nID FROM node WHERE color='red')
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1 )
SELECT * 
FROM path 
WHERE n2 IN (SELECT nID FROM node WHERE color='red');

/*Q3. If your solution to problem 2 incorporates the "red" condition in the recursion by 
constraining the start node to be red, modify your solution to constrain the end node in 
the recursion instead. Conversely, if your solution to problem 2 incorporates the "red" 
condition in the recursion by constraining the end node to be red, modify your solution 
to constrain the start node in the recursion instead*/
WITH recursive
PATH AS (SELECT N1, N2 FROM EDGE
         WHERE n2 IN (SELECT nID FROM node WHERE color='red')
         UNION
		 SELECT E.N1 AS N1, P.N2 AS N2
		 FROM PATH P, EDGE E
		 WHERE P.N1=E.N2 )
SELECT * 
FROM path 
WHERE n1 IN (SELECT nID FROM node WHERE color='red');

/*Q4. Modify one of your previous solutions to also return the lengths of the shortest and 
longest paths between each pair of nodes. Your result should have four columns: the two 
nodeID's, the shortest path, and the longest path.*/
WITH recursive
PATH AS (SELECT N1, N2, 1 AS length FROM EDGE
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2, 1+length AS length
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1)
SELECT n1, n2, MIN(length), MAX(length) 
FROM path 
WHERE n1 IN (SELECT nID FROM node WHERE color='red')
AND n2 IN (SELECT nID FROM node WHERE color='red')
group BY n1, n2;

/*Q5. Modify your solution to problem 3 to also return (n1,n2,0,0) for every pair of nodes (n1≠n2) 
that are both red but there's no path from n1 to n2.*/
WITH recursive
PATH AS (SELECT N1, N2, 1 AS length FROM EDGE
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2, 1+length AS length
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1)
		 
SELECT n1, n2, MIN(length), MAX(length) 
FROM path 
WHERE n1 IN (SELECT nID FROM node WHERE color='red')
AND n2 IN (SELECT nID FROM node WHERE color='red')
group BY n1, n2

union

SELECT node1.nid, node2.nid, 0, 0
FROM node node1, node node2
WHERE node1.color='red' AND node2.color='red' AND NOT EXISTS (SELECT * FROM path WHERE 
n1=node1.nid AND n2=node2.nid) AND node1.nid<>node2.nid;

/*Q6. Find all node pairs n1,n2 that are both red and there's a path of length one or more from n1 to n2 
that passes through exclusively red nodes.*/
WITH recursive
PATH AS (SELECT N1, N2 FROM EDGE
         WHERE n1 IN (SELECT nID FROM node WHERE color='red')
		 AND n2 IN (SELECT nID FROM node WHERE color='red')
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1 AND E.N2 IN (SELECT nID FROM node WHERE color='red'))
SELECT * FROM path;

/*Q7. Find all node pairs n1,n2 such that n1 is yellow and there is a path of length one or more from n1 to n2 
that alternates yellow and blue nodes*/
create view yb as
select n1, n2, node2.color as color
from node node1, node node2, edge
where node2.nID = n2 and node1.nID = n1
and ((node1.color='yellow' and node2.color='blue')
or (node2.color='yellow' and node1.color='blue'));

With Recursive
Path as (
         select * 
         from yb
         where color='blue'
         union
         select p.n1, yb.n2, yb.color
         from Path p, yb
         where p.n2=yb.n1)
select n1, n2 from path order by n1, n2;

/*Q8.   Find the highest-weight path(s) in the graph. Return start node, end node, length of path, 
and total weight.*/
WITH recursive
PATH AS (SELECT N1, N2, 1 AS length, weight AS tw FROM EDGE
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2, length+1 AS length, tw+weight AS tw
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1)
SELECT * FROM path WHERE tw IN (SELECT MAX(tw) FROM path);

/*Q9.Add one more edge to the graph: "insert into Edge values ('L','C',5);"
Your solution to problem 7 probably runs indefinitely now. Modify the query to find the 
highest-weight path(s) in the graph with total weight under 100. Return the number of such paths, 
the minimum length, maximum length, and total weight.*/


/*Q10.Continuing with the additional edge present, find all paths of length exactly 12. 
Return the number of such paths and their minimum and maximum total weights. 
cannot use larger than in the end of loop in this case, consider how the loop proceed! the 
larger than will stop the loop in the first round*/
WITH recursive
PATH AS (SELECT N1, N2, 1 AS L, weight AS tw FROM EDGE
         UNION
		 SELECT P.N1 AS N1, E.N2 AS N2, l+1 AS l, tw+weight AS tw
		 FROM PATH P, EDGE E
		 WHERE P.N2=E.N1 AND l<12)
SELECT COUNT(*), MIN(tw), MAX(tw) FROM path WHERE L=12;