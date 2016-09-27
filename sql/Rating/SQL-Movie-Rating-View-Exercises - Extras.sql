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


 
 /* Q1: Create a view called TNS containing title-name-stars triples, where the movie (title) was reviewed by 
 a reviewer (name) and received the rating (stars). Then referencing only view TNS and table Movie, write a SQL 
 query that returns the lastest year of any movie reviewed by Chris Jackson. You may assume movie names are unique.*/
create view TNS as
select title, name, stars
from Movie M, Reviewer Re, Rating Ra
where M.mID = Ra.mID and Re.rID = Ra.rID;

select max(year)
from Movie M, TNS
where M.title = TNS.title and name='Chris Jackson';

 /* Q2:  Referencing view TNS from Exercise 1 and no other tables, create a view RatingStats containing each movie 
 title that has at least one rating, the number of ratings it received, and its average rating. Then referencing 
 view RatingStats and no other tables, write a SQL query to find the title of the highest-average-rating movie with 
 at least three ratings.*/
create view RatingStats as
select title, count(stars) as ct_stars, avg(stars) as avg_stars
from TNS
group by title;

select title
from RatingStats
where ct_stars>=3 and 
    avg_stars in (select max(avg_stars) from RatingStats where ct_stars>=3);

 /* Q3: Create a view Favorites containing rID-mID pairs, where the reviewer with rID gave the movie with mID the 
 highest rating he or she gave any movie. Then referencing only view Favorites and tables Movie and Reviewer, write 
 a SQL query to return reviewer-reviewer-movie triples where the two (different) reviewers have the movie as their 
 favorite. Return each pair once, i.e., don't return a pair and its inverse.*/
create view Favorites as
select rID, mID
from Rating, (
              select rID, max(stars) as max_stars
              from Rating
              group by rID
			  ) T
where Rating.rID = T.rID and Rating.stars = T.max_stars;

select R1.name, R2.name, M.title
from Favorites F1, Favorites F2, Movie M, Reviewer R1, Reviewer R2
where F1.mID = F2.mID and F1.rID<F2.rID and 
    M.mID=F1.mID and R1.rID=F1.rID and R2.rID=F2.rID;




