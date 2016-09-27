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
 * Your triggers will run over a small data set conforming to the schema. see "social.sql"
 */ 
 
 /*In each exercise you are first asked to create a view, and then to use triggers (SQLite) or rules (PostreSQL) to 
 enable one or more types of modifications to the view. Then you are given some modification commands to 
 execute against the view. To verify correctness of your view-modification triggers, you are asked to compare 
 your final database against our results.
*/

 
 /* Q1:   Create a view called JordanFriend(name,grade) containing the names and grades of students 
 with a friend named Jordan. Your view should initially contain (in some order):
  Gabriel 9
  Tiffany 9
  Andrew 10
  Kyle 12
  Logan 12*/
create view JordanFriend as
select name, grade
from HighSchooler
where ID in (select ID1 
            from Friend, Highschooler
            where ID2=ID and name = 'Jordan');

/*Create a trigger (SQLite) or rule (PostgreSQL) that enables update commands to be executed on 
view JordanFriend. Updates should propagate to the Highschooler table under the assumption that 
(name,grade) pairs uniquely identify students. Do not allow updates that take the grade out of 
the 9-12 range, or that violate uniqueness of (name,grade) pairs; otherwise all updates should be 
permitted*/
create trigger R
instead of update on JordanFriend
for each row
when new.grade<=12 and new.grade>=9
and new.grade not in (select grade from HighSchooler where name=new.name)
begin
update HighSchooler
set grade=new.grade, name=new.name
where grade=old.grade and name=old.name;
end;

/*(a) Execute the following update command:*/
update JordanFriend set grade = grade + 2;
/*Compare your resulting view JordanFriend with ours.
  result(In any order):  
  Gabriel 9
  Tiffany 11
  Andrew  12
  Kyle  12
  Logan  12*/

/*(b) Then execute the following update commands:*/
update JordanFriend set name = 'Tiffany', grade = 10 where name = 'Gabriel';
update JordanFriend set name = 'Jordan' where name = 'Tiffany';
/*Compare your resulting view JordanFriend with ours.
  result(In any order):
  Jordan 9
  Jordan 10
  Jordan 11
  Cassandra 9
  Andrew 12
  Alexis 11
  Kyle 12
  Logan 12*/


/* Q2: Create a view called OlderFriend(ID1,name1,grade1,ID2,name2,grade2) containing the names and 
grades of friends who are at least two years apart in school, with name1/grade1 being the younger 
student. After reloading the original database, your view should initially contain (in some order):

1381 Tiffany   9  1247 Alexis 11
1709 Cassandra 9  1247 Alexis 11
1782 Andrew    10 1304 Jordan 12*/
create view OlderFriend(ID1, name1, grade1, ID2, name2, grade2) as
select H1.ID, H1.name, H1.grade, H2.ID, H2.name, H2.grade
from Highschooler H1, Highschooler H2, Friend F
where H1.ID=F.ID1 and H2.ID=F.ID2 and H1.grade<=H2.grade-2;

/* Create triggers (SQLite) or rules (PostgreSQL) that enable deletions and insertions to be 
executed on view OlderFriend. For insertions, only permit new friendships that obey the restrictions 
of the view and do not create duplicates. Make sure to maintain the symmetric nature of the underlying 
Friend relation even though OlderFriend is not symmetric: a tuple (A,B) is in Friend if and only if 
(B,A) is also in Friend.*/
create trigger R1
instead of delete on OlderFriend
for each row
begin
delete 
from Friend 
where (ID1=old.ID1 and ID2=old.ID2)
   or (ID1=old.ID2 and ID2=old.ID1);
end;

create trigger R2
instead of insert on OlderFriend
for each row
when new.ID1 not in (select ID1 from Friend where ID2=new.ID2)
and new.grade2>=new.grade1+2 and new.name1 in (select name from 
Highschooler where grade=new.grade1 and ID=new.ID1) 
and new.name2 in (select name from Highschooler where grade=new.grade2
and ID=new.ID2)
begin
insert into Friend values(new.ID1, new.ID2);
insert into Friend values(new.ID2, new.ID1);
end;

/*(a) Execute the following deletions: */
  delete from OlderFriend where name2 = 'Alexis';
  delete from OlderFriend where ID1 = 1381;
/* Check the resulting database by writing SQL queries to compute the number of tuples in the Friend 
table and OlderFriend view. Compare your results against ours (Friend contains 36 tuples and 
OlderFriend contains 1 tuple).*/

/*(b) Then execute the following insertions:*/
  insert into OlderFriend values (1510, 'Jordan', 9, 1304, 'Jordan', 12);
  insert into OlderFriend values (1510, 'Jordan', 9, 1468, 'Kris', 10);
  insert into OlderFriend values (1510, 'Jordan', 9, 1468, 'Kris', 11);
  insert into OlderFriend values (1510, 'John', 9, 1247, 'Alexis', 11);
  insert into OlderFriend
      select H1.ID as ID1, H1.name as name1, H1.grade as grade1,
             H2.ID as ID2, H2.name as name2, H2.grade as grade2
      from Highschooler H1, Highschooler H2 where H1.grade >= 10;
/*Check the resulting database by writing SQL queries to compute the number of tuples in the 
Friend table and OlderFriend view. Compare your results against ours.*/
								