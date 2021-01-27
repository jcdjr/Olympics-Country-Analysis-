/*EDA*/

SELECT *
FROM athletes
LIMIT 5;

SELECT *
FROM countries
LIMIT 5;

SELECT *
FROM country_stats
LIMIT 5;

SELECT *
FROM summer_games
LIMIT 5;

SELECT *
FROM winter_games
LIMIT 5;

/*Count number of athetes by country name in the summer games*/

SELECT country, COUNT(DISTINCT(athlete_id))
FROM summer_games INNER JOIN countries ON summer_games.country_id = countries.id
GROUP BY country;

/*How many evets did each country compete in across boh summer and winter games (use country_id, not country_name)*/

SELECT country_id, COUNT(DISTINCT(event))
FROM summer_games
GROUP BY country_id
UNION
SELECT country_id, COUNT(DISTINCT(event))
FROM winter_games
GROUP BY country_id
ORDER BY country_id

/*Find country names where the population decreased from 2000 to 2006*/

SELECT country, c1.year, c1.pop_in_millions, c2.year, c2.pop_in_millions
FROM country_stats AS c1
	INNER JOIN country_stats AS c2
	USING (country_id)
	INNER JOIN countries ON c1.country_id = countries.id
WHERE c1.year LIKE '2000%'
AND c2.year LIKE '2006%'
AND CAST(c1.pop_in_millions AS float) > CAST(c2.pop_in_millions AS float);

-------------------------------------CTEs----------------------------------

/* Write a CTE called top_gold_winter to find the top 5 gold-medal-winning countries for winter games in the database.
Then write query to select the countries and the number of medals from the CTE where the total gold medals won is
greater than or equal to 5 */

WITH top_gold_winter AS (SELECT country_id, SUM(gold) AS total_gold
						FROM winter_games
						WHERE gold IS NOT NULL
						GROUP BY country_id
						ORDER BY total_gold DESC
						LIMIT 5)
SELECT c.country, tgw.total_gold
FROM countries AS c
	INNER JOIN
	top_gold_winter
	AS tgw
	ON c.id = tgw.country_id
WHERE tgw.total_gold >= 5
ORDER BY tgw.total_gold DESC;

/*Write a CTE called tall_athletes to find the athletes in the database who are taller than the average height for all athletes in the
database. Next query that data to get just the female athletes who are taller than the average height for all athletes and are over the
age of 30.*/
				   
WITH tall_athlete AS(
					SELECT name, height AS athlete_height
					FROM athletes
					WHERE height >(SELECT AVG(height) FROM athletes)
					GROUP BY name, height
					)
SELECT ah.name, a.gender, a.age
FROM athletes AS a INNER JOIN tall_athlete AS ah 
					ON a.name = ah.name
WHERE a.gender = 'F'
	AND a.age > 30
GROUP BY ah.name, a.gender, a.age;

/* write a CTE called tall_over30_female_athletes that returns the final results of exercise above. 
Next query the CTE to find the average weight for the over 30 female athletes */

WITH tall_over30_female_athletes as (SELECT *
									FROM athletes
									WHERE height > (SELECT AVG (height) FROM athletes)
									AND gender = 'F'
									AND age >30)
SELECT ROUND(AVG(weight),2)
FROM tall_over30_female_athletes;

--Method 2
WITH tall_females_over30 AS (SELECT name, gender, age, height,weight
							FROM athletes
							WHERE gender = 'F' AND age > 30
							AND height > (SELECT AVG(height) FROM athletes)
							ORDER BY height DESC)
SELECT ROUND(AVG(weight),2)
FROM tall_females_over30;

--Method 3
WITH tall_over30_female_athletes as (SELECT name, height, gender, age, weight
								FROM athletes 
								WHERE gender LIKE 'F'
								AND age > 30
								GROUP BY name, height, gender, age, weight
								HAVING height > 
										(SELECT AVG(height) FROM athletes)
								ORDER BY height DESC)
SELECT ROUND(AVG(weight),2) as avg_weight
FROM tall_over30_female_athletes;

-----------------------------------Reports---------------------------------------

/*1. Create a query to generate the report below. a. Display the country name, 4-digit year, 
count of Nobel prize winners when that count is at least 1, 
and country size according to the following business rule: 
large - population greater than 100 million 
medium – population between 50 and 100 million 
small – less than 50 million 
b. Sort the results so the country and year with the largest number of Nobel prize winners is at the top. 
c. Export the results, and then open the file with Excel. Create a chart to effectively communicate the findings*/

SELECT c.country, DATE_PART('year', cs.year::date) AS calendar_year, SUM(cs.nobel_prize_winners) AS nobel_prize_winners,
CASE WHEN cs.pop_in_millions::float > 100 THEN 'large'
	WHEN cs.pop_in_millions::float < 50 THEN 'small'
	ELSE 'medium'
	END country_size
FROM countries AS c INNER JOIN country_stats AS cs
ON c.id = cs.country_id
WHERE nobel_prize_winners > 0
GROUP BY c.country, cs.year, cs.pop_in_millions
ORDER BY SUM(cs.nobel_prize_winners) DESC;

/*2. Create the report below using the olympics database. 
Show a row for each country and each year. Use COALESCE() to display unknown when gdp is NULL*/

SELECT c.country, DATE_PART('year', cs.year::date) AS calendar_year, COALESCE(cs.gdp::varchar,'Unkown')GDP_amount
FROM countries AS c INNER JOIN country_stats AS cs
ON c.id = cs.country_id




