/* Students at your hometown high school have decided to organize their social network 
 * using databases. So far, they have collected information about sixteen students in four 
 * grades, 9-12. Here's the schema: 
 * 
 * Highschooler ( ID, name, grade ) 
 * English: There is a high school student with unique ID and a given first name in a certain grade. 
 * 
 * Friend ( ID1, ID2 ) 
 * English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if 
 * (123, 456) is in the Friend table, so is (456, 123). 
 * 
 * Likes ( ID1, ID2 ) 
 * English: The student with ID1 likes the student with ID2. Liking someone is not necessarily 
 * mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
 * 
 * Your queries will run over a small data set conforming to the schema. see "social.sql"
 */ 
 
 /* Q1: For every situation where student A likes student B, but student B likes a different 
 student C, return the names and grades of A, B, and C. */
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM 
    (
    SELECT L1.ID1 AS ID1, L1.ID2 AS ID2, L2.ID2 AS ID3
    FROM Likes L1, Likes L2
    WHERE L1.ID2=L2.ID1 AND L2.ID2<>L1.ID1
    ) ABC, Highschooler H1, Highschooler H2, Highschooler H3
WHERE H1.ID=ABC.ID1 AND H2.ID=ABC.ID2 AND H3.ID=ABC.ID3;

 /* Q2: Find those students for whom all of their friends are in different grades from 
 themselves. Return the students' names and grades.*/
SELECT DISTINCT H.name, H.grade
FROM Highschooler H, Friend
WHERE H.ID=Friend.ID1 AND Friend.ID1 NOT IN 
                                            (
                                            SELECT F.ID1
                                            FROM Friend F, Highschooler H1, Highschooler H2
                                            WHERE F.ID1=H1.ID AND F.ID2=H2.ID AND H1.grade=H2.grade
                                            );

 /* Q3: What is the average number of friends per student? (Your result should be 
 just one number.)*/
SELECT AVG(Ct)
FROM 
    (
    SELECT ID, ifnull(COUNT(*), 0) AS Ct
    FROM Highschooler H Left join Friend F on H.ID=F.ID1
    GROUP BY ID
    );

/* Q4: Find the number of students who are either friends with Cassandra or are 
friends of friends of Cassandra. Do not count Cassandra, even though technically 
she is a friend of a friend. */
SELECT COUNT(*)
FROM 
    (
        SELECT Friend.ID2
        FROM Friend
        WHERE Friend.ID1 IN 
                      (
                       SELECT Friend.ID2
                       FROM Friend, Highschooler H
                       WHERE H.ID=Friend.ID1 AND H.name='Cassandra'
                       )
              AND Friend.ID2 NOT IN 
		                       (
								SELECT ID 
								FROM Highschooler 
								WHERE Highschooler.name='Cassandra'
							   )
    UNION
        SELECT Friend.ID2
        FROM Friend, Highschooler H
        WHERE H.ID=Friend.ID1 AND H.name='Cassandra'
    );

/* Q5: Find the name and grade of the student(s) with the greatest number of friends.*/
select name, grade
from Friend F, Highschooler H
where F.ID1 = H.ID
group by ID1
having count(ID2) in (
                     SELECT MAX(Ct)
                     FROM 
                         (
                         SELECT ID1, COUNT(*) AS Ct
                         FROM Friend
                         GROUP BY ID1
                          )
		             );

