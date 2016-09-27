/* You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. 
 * There's not much data yet, but you can still try out some interesting queries. Here's the schema: 
 *
 * Movie ( mID, title, year, director ) 
 * English: There is a movie with ID number mID, a title, a release year, and a director. 
 * 
 * Reviewer ( rID, name ) 
 * English: The reviewer with ID number rID has a certain name. 
 * 
 * Rating ( rID, mID, stars, ratingDate ) 
 * English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
 * 
 * Your queries will run over a small data set conforming to the schema. see "rating.sql"
 */
 
 /* Q1: Find the titles of all movies directed by Steven Spielberg. */
select title
from Movie
where director = 'Steven Spielberg';

 /* Q2: Find all years that have a movie that received a rating of 4 or 5, and 
 sort them in increasing order.*/
SELECT year
FROM Movie
WHERE mID in (select mID from Rating where stars=4 or stars=5)
ORDER by year;

 /* Q3: Find the titles of all movies that have no ratings.*/
select title
from Movie
where mID not in (select mID from Rating);

/* Q4: Some reviewers didn't provide a date with their rating. Find the names
of all reviewers who have ratings with a NULL value for the date. */
select name
from Reviewer
where rID in (select rID from Rating where ratingDate is null);

/* Q5: Write a query to return the ratings data in a more readable format: 
reviewer name, movie title, stars, and ratingDate. Also, sort the data, first 
by reviewer name, then by movie title, and lastly by number of stars.  */
select name, title, stars, ratingDate
from ( Movie join Rating using(mID) ) join Reviewer using(rID)
order by name, title, stars;

/* Q6: For all cases where the same reviewer rated the same movie twice and
 gave it a higher rating the second time, return the reviewer's name and the 
 title of the movie.  */
SELECT name, title
FROM 
    (
	select rID, mID, count(*) AS num 
	from Rating 
	group by rID, mID
	) 
	CT, Rating Ra, Movie M, Reviewer Re
WHERE 
    CT.rID = Ra.rID and CT.mID = Ra.mID and Ra.mID = M.mID and Ra.rID = Re.rID and 
    num=2 AND exists (SELECT * FROM Rating R1 WHERE R1.rID = Ra.rID And 
                     R1.mID=Ra.mID and R1.ratingDate > Ra.ratingDate
					 AND R1.stars>Ra.stars);
										
/* Q7: For each movie that has at least one rating, find the highest number of stars that 
movie received. Return the movie title and number of stars. Sort by movie title.*/
SELECT title, MAX(stars)
FROM Rating JOIN Movie using(mID)
GROUP BY mID
ORDER BY title;

/* Q8: For each movie, return the title and the 'rating spread', that is, the difference between 
highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, 
then by movie title. */
SELECT title, (MAX(stars)-MIN(stars)) AS spread
FROM Rating JOIN Movie using(mID)
GROUP BY mID
ORDER BY spread DESC, title;

/* Q9: Find the difference between the average rating of movies released before 1980 and the 
average rating of movies released after 1980. (Make sure to calculate the average rating for each 
movie, then the average of those averages for movies before 1980 and movies after. Don't just 
calculate the overall average rating before and after 1980.) */
SELECT distinct
    (
        (
	    SELECT AVG(avestar)
        FROM (SELECT mID, avg(stars) AS avestar FROM Rating GROUP BY mID) M 
        JOIN Movie using(mID)
		WHERE year<1980
		) 
    -
        (
		SELECT AVG(avestar)
        FROM (SELECT mID, avg(stars) AS avestar FROM Rating GROUP BY mID) M 
        JOIN Movie using(mID)
		WHERE year>=1980
		)
    ) AS result
FROM Movie;		