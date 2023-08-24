
-- 1. Retrieve all the records from the Space table. --

SELECT * FROM Space..Indian_Satellites;

-- 2. Retrieve the names of all satellites launched by the Earth Sciences. --

SELECT name, launch_site FROM Space..Indian_Satellites
WHERE Department  = 'Earth Sciences' AND launch_site IS NOT NULL;

-- 3. Retrieve the count of satellites launched from each Department. --

SELECT Department, COUNT(*) AS Launch_Numbers
FROM Space..Indian_Satellites
GROUP BY Department;

-- 4. Retrieve the names and launch dates of satellites with a successful launch status, sorted by launch date in descending order. --

SELECT name, launch_date FROM Space..Indian_Satellites
WHERE launch_status = 1
ORDER BY launch_status DESC;

-- 5. Retrieve the names of satellites launched in the year 2017, along with their launch site. --

SELECT name, launch_site FROM Space..Indian_Satellites
WHERE launch_date LIKE '%2017%';
--WHERE YEAR(launch_date) = 2017;--

-- 6. Retrieve the satellite name with the highest number of characters in its name. --

SELECT name FROM Space..Indian_Satellites
ORDER BY LEN(name) DESC
OFFSET 5 ROWS FETCH NEXT 1 ROWS ONLY;

-- 7. Retrieve the launch sites where all satellite launches have been successful -

SELECT launch_site AS Launches FROM Space..Indian_Satellites
GROUP BY launch_site
HAVING SUM(launch_status) = COUNT(*);

-- 8. Retrieve the satellite name and the department responsible for its launch. --

SELECT Space..Indian_Satellites.name, Space..Indian_Satellites.Department
FROM Space..Indian_Satellites;

-- /9. Display the count of satellites launched by each department. --

SELECT Department, COUNT(*) AS Launch_Count
FROM Space..Indian_Satellites
GROUP BY Department;

-- /10. Count number of satellite launches over the years. --

SELECT YEAR(launch_date) AS Launch_Year, COUNT(*) AS Launch_Count
FROM Space..Indian_Satellites
GROUP BY launch_date
ORDER BY Launch_Year DESC

-- /11. Count of Launch statuses(success (1) / failure (0) / Not Launched (Null)) of the satellites. --

SELECT launch_status, COUNT(*) AS Status_Count
FROM Space..Indian_Satellites
GROUP BY launch_status;

-- /12.  Retrive the launch dates and launch sites of the satellites. --

SELECT launch_date , launch_site 
FROM Space..Indian_Satellites 
ORDER BY launch_date DESC;

-- /13. Compare the number of satellite launches at different launch sites. --

SELECT launch_site, COUNT(*) AS launch_count, MAX(launch_date) AS last_launch_date
FROM Space..Indian_Satellites
GROUP BY launch_site;

-- /14. Retrive distribution of satellite launches by month and year (success (1) / failure (0) / Not Launched (Null)) --

SELECT MONTH(launch_date) AS Launch_Month, YEAR(launch_date) AS Launch_Year, COUNT(*) AS launch_count
FROM Space..Indian_Satellites
GROUP BY launch_date, launch_date
ORDER BY launch_year, launch_month DESC;

-- 15. Retrieve the satellite name, launch date, and launch site for the satellites with the earliest launch date. --

SELECT name, launch_date, launch_site
FROM Space..Indian_Satellites
WHERE launch_date = (SELECT MIN(launch_date) FROM Space..Indian_Satellites);

-- 16. Retrieve the satellite name and launch date for the satellites launched from the most frequent launch site. --

SELECT s.name, s.launch_date FROM Space..Indian_Satellites s JOIN (
SELECT launch_site, COUNT(*) AS site_count FROM Space..Indian_Satellites GROUP BY launch_site
HAVING COUNT(*) = ( SELECT MAX(launch_count) FROM ( SELECT launch_site, COUNT(*) AS launch_count
FROM Space..Indian_Satellites GROUP BY launch_site ) AS site_counts ) ) 
AS most_frequent ON s.launch_site = most_frequent.launch_site;

-- 17. Retrieve the satellite name and launch date for the satellites launched from a site where all launches have been successful. --

SELECT s.name, s.launch_date FROM Space..Indian_Satellites s
WHERE s.launch_site IN ( SELECT launch_site FROM Space..Indian_Satellites
GROUP BY launch_site HAVING COUNT(*) = SUM(launch_status));

-- 18. Retrieve the satellite name and launch date for the satellites launched in the same month and year as the satellite named "Aryabhatta". --

SELECT s.name, s.launch_date FROM Space..Indian_Satellites s WHERE MONTH(s.launch_date) = (
SELECT MONTH(launch_date) FROM Space..Indian_Satellites WHERE name = 'Satellite_A') AND YEAR(s.launch_date) = 
( SELECT YEAR(launch_date) FROM Space..Indian_Satellites WHERE name = 'Rohini RS-1 (Rohini-1B)' );

-- 19. Retrieve the satellite name and launch site for the satellites with the highest launch status count. --

SELECT name, launch_site FROM Space..Indian_Satellites 
WHERE launch_status = ( SELECT MAX(launch_status) FROM ( SELECT launch_status, COUNT(*) AS launch_count
FROM Space..Indian_Satellites
GROUP BY launch_status ) AS status_counts );

-- 20. Retrieve the average launch time(in minutes) for each launch site. --

SELECT launch_site, AVG(CAST(launch_time AS DECIMAL)) 
FROM Space..Indian_Satellites
GROUP BY launch_site;

-- 21. Retrieve the satellite name and launch date for the satellites launched after a specified date.

SELECT name, launch_date FROM Space..Indian_Satellites
WHERE launch_date > '2008-04-28';

-- 22. Retrieve the satellite name and department for the satellites launched on the same day as the satellite named "Cartosat-2C". --

SELECT s.name, s.department
FROM Space..Indian_Satellites s
JOIN Space..Indian_Satellites s2 ON s.launch_date = s2.launch_date
WHERE s2.name = 'Cartosat-2C';

-- 23. Retrieve the satellite name and launch date for the satellites launched in the same month as the satellite named "" but from a different department. --

SELECT s.name, s.launch_date FROM Space..Indian_Satellites s
JOIN Space..Indian_Satellites s2 ON MONTH(s.launch_date) = MONTH(s2.launch_date)
WHERE s2.name = 'SROSS-2' AND s.department <> s2.department;

-- 24. Retrieve the satellite name and launch site for the satellites with the highest launch time. --

SELECT name, launch_site, launch_time FROM Space..Indian_Satellites
WHERE launch_time = ( SELECT MAX(launch_time) FROM Space..Indian_Satellites );

-- 25. Retrieve the satellite name and launch site for the satellite launched on the latest date for each department. --

SELECT s.name, s.launch_site, launch_date FROM Space..Indian_Satellites s 
JOIN ( SELECT department, MAX(launch_date) AS latest_date
FROM Space..Indian_Satellites
GROUP BY department ) 
AS latest ON s.department = latest.department AND s.launch_date = latest.latest_date;

