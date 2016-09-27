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
 
 /* Q1: Find the names of all reviewers who rated Gone with the Wind. */
select name
from Reviewer
where rID in (
		      select rID 
			  from Rating 
			  where mID in (select mID from Movie where title='Gone with the Wind')
              );

 /* Q2: For any rating where the reviewer is the same as the director of the movie, return
the reviewer name, movie title, and number of stars.*/
SELECT name, title, stars
FROM Rating Ra, Reviewer Re, Movie M
WHERE Ra.rID = Re.rID and M.mID = Ra.mID and name=director
ORDER by year;

 /* Q3: Return all reviewer names and movie names together in a single list, alphabetized. 
 (Sorting by the first name of the reviewer and first word in the title is fine; no need for 
 special processing on last names or removing "The".)*/
    select name
    from Reviewer
Union
    select title as name
    from Movie
    order by name;

/* Q4: Find the titles of all movies not reviewed by Chris Jackson.*/
select title
from Movie M
where mID not in (
                  select mID
				  from Rating Ra, Reviewer Re
				  where Ra.rID = Re.rID and name = 'Chris Jackson'
				  );

/* Q5: For all pairs of reviewers such that both reviewers gave a rating to the same movie, 
return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, 
and include each pair only once. For each pair, return the names in the pair in alphabetical 
order. */
select distinct Re1.name, Re2.name
from Reviewer Re1, Reviewer Re2, Rating Ra1, Rating Ra2
where Re1.name<Re2.name and Ra1.rID = Re1.rID and Ra2.rID = Re2.rID
      and Ra1.mID = Ra2.mID
order by Re1.name;

/* Q6: For each rating that is the lowest (fewest stars) currently in the database, 
return the reviewer name, movie title, and number of stars.*/
select name, title, stars
from Movie M, Rating Ra, Reviewer Re
where M.mID = Ra.mID and Re.rID = Ra.rID
and stars in (
              select min(stars) as minstar
              from Rating
              );
										
/* Q7: List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order.*/
select title, avg(stars) as avgstar
from Movie M, Rating R
where M.mID = R.mID
group by M.mID
order by avgstar desc, title;

/* Q8: Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.) */
select name
from Reviewer Re, (
                   select  rID, count(stars) as CT_stars
                   from Rating
                   group by rID
				   ) CT
where Re.rID = CT.rID and CT_stars>=3;

/* Q9: Some directors directed more than one movie. For all such directors, return the 
titles of all movies directed by them, along with the director name. Sort by director name,
then movie title. (As an extra challenge, try writing the query both with and without 
COUNT.)  */
select title, Movie.director
from Movie,  (
              select director, count(mID) as CT_M
              from Movie
              group by director
		     ) CT
where Movie.director = CT.director and CT_M>1
order by Movie.director, title;

/* Q10:Find the movie(s) with the highest average rating. Return the movie title(s) and 
average rating. (Hint: This query is more difficult to write in SQLite than other systems;
you might think of it as finding the highest average rating and then choosing the movie(s)
with that average rating.) */
select title, avg(stars) as avgstar
from Movie,  Rating
where Rating.mID = Movie.mID
group by Rating.mID
having avgstar in
                 (
                  select max(avgstar)
                  from
                      (
                       select mID, avg(stars) as avgstar
                       from Rating
                       group by mID
                       )
                  );

/* Q11: Find the movie(s) with the lowest average rating. Return the movie title(s) and 
average rating. (Hint: This query may be more difficult to write in SQLite than other 
systems; you might think of it as finding the lowest average rating and then choosing the 
movie(s) with that average rating.) */
select title, avg(stars) as avgstar
from Movie,  Rating
where Rating.mID = Movie.mID
group by Rating.mID
having avgstar in
                  (
                   select min(avgstar)
                   from
                        (
                         select mID, avg(stars) as avgstar
                         from Rating
                         group by mID
                        )
                   );

/* Q12: For each director, return the director's name together with the title(s) of the movie(s) 
they directed that received the highest rating among all of their movies, and the value of 
 that rating. Ignore movies whose director is NULL.   */
 select distinct M.director, title, maxstar
 from  Movie M, Rating Ra,
                           (
                            select director, max(stars) as maxstar
                            from Rating Ra, Movie M
                            where Ra.mID = M.mID and director is not null
                            group by director
                            ) T
 where M.director=T.director and M.mID=Ra.mID and T.maxstar=Ra.stars;
