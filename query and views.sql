--The TOP_RATED_MOVIES view displays the top-rated movies in the streaming service, 
--based on the average user rating. 
--It includes the movie name, director, 
--average rating, and number of views. 
--This information can help the business identify popular movies 
--and make informed decisions on which movies to prioritize and promote. 
--This, in turn, can increase customer satisfaction and loyalty.

CREATE OR REPLACE VIEW TOP_RATED_MOVIES AS
SELECT m."movieName" AS movie_name, 
       d."firstname" || ' ' || d."lastname" AS director,
       ROUND(AVG(mp."userrating"), 2) AS avg_rating,
       COUNT(mp."datewatched") AS num_watched
FROM "movie" m
JOIN "movieprofile" mp ON m."movieID" = mp."movieID"
JOIN "director" d ON m."directorID" = d."directorID"
GROUP BY m."movieID", m."movieName", d."firstname", d."lastname"
ORDER BY avg_rating DESC;

--The "MOST_WATCHED_MOVIES" view presents a list of movies that have been watched the most,
--along with their genre and director.
--This report will allow the business to identify popular movies and trends in viewing habits. 
--This, in turn, can inform decisions about programming and promotions, 
--which can increase customer engagement and retention.

CREATE OR REPLACE VIEW MOST_WATCHED_MOVIES AS
SELECT COUNT(mv."movieID") AS numberWatched, 
       mv."movieName" AS movie_name, 
       g."genreDesc" AS movie_genre, 
       d."firstname" || ' ' || d."lastname" AS director
FROM "movie" mv
JOIN "genremovie" gm ON mv."movieID" = gm."movieID"
JOIN "genre" g ON gm."genreID" = g."genreID"
JOIN "director" d ON mv."directorID" = d."directorID"
JOIN "movieprofile" mp ON mv."movieID" = mp."movieID"
GROUP BY mv."movieID", mv."movieName", g."genreDesc", d."firstname", d."lastname"
ORDER BY numberWatched DESC;

--The CustomerView displays customer information such as 
--username, email, subscription plan, total amount spent, and the number of movies watched. 
--This view provides insight into customer behavior, 
--allowing the business to understand customer preferences 
--and tailor their offerings accordingly. This can help the business 
--make data-driven decisions to improve customer satisfaction and loyalty.

CREATE OR REPLACE VIEW CustomerView AS
SELECT u."userID", u."userName", u."email", s."planName" AS subscriptionplan,
       SUM(t."amount") AS totalamountspent, 
       COUNT(DISTINCT mp."movieID") AS numberofmovieswatched
FROM "userAccount" u
JOIN "transactionHistory" t ON u."userID" = t."userID"
JOIN "userProfile" up ON u."userID" = up."userID"
JOIN "movieProfile" mp ON mp."profileID" = up."profileID"
JOIN "subscriptionPlan" s ON u."planID" = s."planID"
GROUP BY u."userID", u."userName", u."email", s."planName";

--The "popular_genre_view" view displays the most popular movie genres, 
--based on the number of movies in each genre and their average user rating. 
--It joins the "genre", "genremovie", "movie", and "movieprofile" 
--tables and groups the results by genre description. The view is 
--sorted by average rating in descending order, providing insight 
--into the genres that are most popular among customers. 
--This information can help the business make informed decisions 
--about programming and promotions, which can increase customer engagement and retention.

CREATE OR REPLACE VIEW popular_genre_view AS
SELECT g."genreDesc" AS genre, 
       COUNT(*) AS nummovies, 
       ROUND(AVG(mp."userrating"), 2) AS avgrating
FROM "genre" g
JOIN "genreMovie" gm ON gm."genreID" = g."genreID"
JOIN "movie" m ON gm."movieID" = m."movieID"
JOIN "movieProfile" mp ON m."movieID" = mp."movieID"
GROUP BY g."genreDesc"
ORDER BY avgrating DESC;