/* You've started a new movie-rating website, and you've been collecting data on reviewers' ratings 
 * of various movies. Here's the schema: 
 *
 * Movie ( mID, title, year, director ) 
 * English: There is a movie with ID number mID, a title, a release year, and a director. 
 * 
 * Reviewer ( rID, name ) 
 * English: The reviewer with ID number rID has a certain name. 
 * 
 * Rating ( rID, mID, stars, ratingDate ) 
 * English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
 
 * The exercises will run over a small data set conforming to the schema, the data and schema is in "rating.sql" 
 * In addition to the base tables, you need to create three views for the exercise: 

/* View LateRating contains movie ratings after January 20, 2011. 
 * The view contains the movie ID, movie title, number of stars, and rating date.*/
create view LateRating as 
select distinct R.mID, title, stars, ratingDate 
from Rating R, Movie M 
where R.mID = M.mID 
and ratingDate > '2011-01-20' 
 
/* View HighlyRated contains movies with at least one rating above 3 stars. 
 * The view contains the movie ID and movie title.*/ 
create view HighlyRated as 
select mID, title 
from Movie 
where mID in (select mID from Rating where stars > 3) 
  
/* View NoRating contains movies with no ratings in the database. 
 * The view contains the movie ID and movie title.*/
create view NoRating as 
select mID, title 
from Movie 
where mID not in (select mID from Rating) 


 
 /* Q1: Write an instead-of trigger that enables updates to the title attribute of view LateRating.
 
Policy: Updates to attribute title in LateRating should update Movie.title for the corresponding 
movie. (You may assume attribute mID is a key for table Movie.) Make sure the mID attribute of 
view LateRating has not also been updated -- if it has been updated, don't make any changes. 
Don't worry about updates to stars or ratingDate.*/
create trigger R
instead of update on LateRating
for each row
when new.mID=old.mID
begin
update Movie set title=new.title
where mID=new.mID;
end;

 /* Q2: Write an instead-of trigger that enables updates to the stars attribute of view LateRating. 
 
Policy: Updates to attribute stars in LateRating should update Rating.stars for the corresponding 
movie rating. (You may assume attributes [mID,ratingDate] together are a key for table Rating.) 
Make sure the mID and ratingDate attributes of view LateRating have not also been updated -- if 
either one has been updated, don't make any changes. Don't worry about updates to title.*/
create trigger R
instead of update on LateRating
for each row
when new.mID=old.mID and new.ratingDate=old.ratingDate
begin
update Rating 
set stars=new.stars 
where mID=old.mID and ratingDate=old.ratingDate;
end;

 /* Q3: Write an instead-of trigger that enables updates to the mID attribute of view LateRating. 

Policy: Updates to attribute mID in LateRating should update Movie.mID and Rating.mID for the 
corresponding movie. Update all Rating tuples with the old mID, not just the ones contributing 
to the view. Don't worry about updates to title, stars, or ratingDate.*/
create trigger R
instead of update of mID on LateRating
for each row
begin
update Movie set mID=new.mID where mID=old.mID;
update Rating set mID=new.mID where mID=old.mID;
end;

/* Q4: Finally, write a single instead-of trigger that combines all three of the previous triggers 
to enable simultaneous updates to attributes mID, title, and/or stars in view LateRating. Combine 
the view-update policies of the three previous problems, with the exception that mID may now be 
updated. Make sure the ratingDate attribute of view LateRating has not also been updated -- if 
it has been updated, don't make any changes.*/
create trigger R
instead of update on LateRating
for each row
when new.ratingDate=old.ratingDate
begin
update Movie set mID=new.mID, title=new.title where mID=old.mID;
update Rating set stars=new.stars where mID=old.mID  and ratingDate=old.ratingDate;
update Rating set mID=new.mID where mID=old.mID;
end;

/* Q5: Write an instead-of trigger that enables deletions from view HighlyRated. 

Policy: Deletions from view HighlyRated should delete all ratings for the corresponding movie 
that have stars > 3.*/
create trigger R
instead of delete on HighlyRated
for each row
begin
delete from Rating where mID=old.mID and stars>3;
end;

/* Q6: Write an instead-of trigger that enables deletions from view HighlyRated. 

Policy: Deletions from view HighlyRated should update all ratings for the corresponding movie 
that have stars > 3 so they have stars = 3.*/
create trigger R
instead of delete on highlyrated
for each row
begin
update Rating set stars=3 where mID=old.mID and stars>3;
end;

/* Q7: Write an instead-of trigger that enables insertions into view HighlyRated. 

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie 
table. (Otherwise, do nothing.) Insertions into view HighlyRated should add a new rating for the 
inserted movie with rID = 201, stars = 5, and NULL ratingDate.*/
create trigger R
instead of insert on HighlyRated
for each row
when new.mID in (select mID from Movie where title=new.title)
begin
insert into rating values (201, new.mID, 5, NuLL);
end;

/* Q8: Write an instead-of trigger that enables insertions into view NoRating. 

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie 
table. (Otherwise, do nothing.) Insertions into view NoRating should delete all ratings for the 
corresponding movie.*/
create trigger R
instead of insert on NoRating
for each row
when new.title in (select title from Movie where mID=new.mID)
begin
delete from Rating where mID=new.mID;
end;

/* Q9: Write an instead-of trigger that enables deletions from view NoRating. 

Policy: Deletions from view NoRating should delete the corresponding movie from the Movie table.*/
create trigger R
instead of delete on NoRating
for each row
begin
delete from Movie where mID=old.mID;
end;

/* Q10: Write an instead-of trigger that enables deletions from view NoRating. 

Policy: Deletions from view NoRating should add a new rating for the deleted movie with rID = 201, stars = 1, 
and NULL ratingDate.*/
create trigger R
instead of delete on NoRating
for each row
begin
insert into Rating values(201, old.mID, 1, Null);
end;