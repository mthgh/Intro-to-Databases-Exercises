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
 
 /* Q1: Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade.
That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler 
A in the same grade as 'Friendly'.*/
create trigger R
before insert on Highschooler
for each row
when new.name='Friendly'
begin
    insert into Likes
	select new.ID, Highschooler.ID
	from Highschooler
	where new.grade=Highschooler.grade;
end;

 /* Q2: Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has 
 a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has 
 a null value for grade, change it to 9.*/
create trigger R1
after insert on Highschooler
for each row
when new.grade<9 or new.grade>12
begin
    update Highschooler
	set grade = null
	where Highschooler.ID = new.ID;
end;

create trigger R2
after insert on Highschooler
for each row
when new.grade is null
begin
    update Highschooler
	set grade=9
	where Highschooler.ID=new.ID;
end;

 /* Q3:Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from 
 Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too. Don't 
 worry about updates to the Friend table.*/
create trigger R1
after delete on Friend
for each row
begin
    delete 
	from Friend
	where ID1=old.ID2 and ID2=old.ID1;
end;

create trigger R2
after insert on Friend
for each row
begin
    insert into Friend 
	select ID2, ID1
	from Friend
	where ID1=new.ID1 and ID2=new.ID2;
end;

/* Q4: Write a trigger that automatically deletes students when they graduate, i.e., when their grade is 
updated to exceed 12. */
create trigger R
after update of grade on Highschooler
for each row
when new.grade>12
begin
    delete 
	from Highschooler
	where ID=new.ID;
end;

/* Q5: Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated 
to exceed 12 (same as Question 4). In addition, write a trigger so when a student is moved ahead one grade, then 
so are all of his or her friends.*/
create trigger R1
after update of grade on Highschooler
for each row
when new.grade = old.grade + 1
begin
    update Highschooler
	set grade = grade + 1
	where ID in (
	            select ID2
				from Friend
				where ID1 = new.ID
	            );
end;

create trigger R
after update of grade on Highschooler
for each row
when new.grade>12
begin
    delete 
	from Highschooler
	where ID=new.ID;
end;

/* Q6:Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B 
and C were friends, make B and C no longer friends. Don't forget to delete the friendship in both directions, and 
make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not 
changed.*/
create trigger R
after update on Likes
for each row
when new.ID1=old.ID1 
begin
    delete
	from Friend
	where (ID1=new.ID2 and ID2=old.ID2)
	    or (ID1=old.ID2 and ID2=new.ID2);
end;
										