# Exploring results of olympic winter and summer games (2000-2016). 

**Joining Data**

1. Count the number of athletes by country name in the summer games. 

2. How many events did each country compete in across both summer and winter games (just use country_id, not country name).

3. Find country names where the population decreased from 2000 to 2006.

**Reporting**

2. Create a query to generate the report below. 
    a. Display the country name, 4-digit year, count of Nobel prize winners when that count is at least 1, and country size according to the following business rule:               
               - large - population greater than 100 million 
               - medium – population between 50 and 100 million 
               - small – less than 50 million 
    b. Sort the results so the country and year with the largest number of Nobel prize winners is at the top. 
    c. Export the results, and then open the file with Excel. Create a chart to effectively communicate the findings.

3. Create the report below using the olympics database. Show a row for each country and each year. Use COALESCE() to display unknown when gdp is NULL.

**Common Table Expressions**

4. Write a CTE called top_gold_winter to find the top 5 gold-medal-winning countries for winter games in the database. Then write query to select the countries and the number of medals from the CTE where the total gold medals won is greater than or equal to 5. 

5. Write a CTE called tall_athletes to find the athletes in the database who are taller than the average height for all athletes in the database. Next query that data to get just the female athletes who are taller than the average height for all athletes and are over the age of 30. 

6. Write a CTE called tall_over30_female_athletes that returns the final results of exercise 2 above. Next query the CTE to find the average weight for the over 30 female athletes.

**Window Functions**

7. Use a window function in the olympics database to find the number of times each country had an athlete compete in the winter games. Be sure to return the country name along with the count of times that country had an athlete competing.


