--EX1
SELECT NAME FROM CITY
WHERE COUNTRYCODE="USA"
AND POPULATION>120000;
--EX2
SELECT * FROM CITY 
WHERE COUNTRYCODE = "JPN";
--EX3
SELECT CITY,STATE FROM STATION;
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) IN ('A','E','I','O','U'); 
--EX4
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) IN ('A','E','I','O','U'); 
--EX5
SELECT DISTINCT CITY FROM STATION
WHERE RIGHT(CITY,1) IN ('A','E','I','O','U'); 
--EX6 
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) NOT IN ('A','E','I','O','U'); 
--EX7
SELECT NAME FROM EMPLOYEE
ORDER BY NAME;
--EX8
SELECT NAME FROM EMPLOYEE
WHERE SALARY > 2000 AND MONTHS <10
ORDER BY EMPLOYEE_ID;
--EX9
SELECT PRODUCT_ID FROM PRODUCTS
WHERE LOW_FATS = 'Y' AND RECYCLABLE = "Y";
--EX10
SELECT NAME FROM CUSTOMER
WHERE REFEREE_ID != "2" OR REFEREE_ID IS NULL ;
--EX11
SELECT NAME,POPULATION,AREA FROM WORLD
WHERE AREA >= 3000000 OR POPULATION >= 25000000;
--EX12
SELECT DISTINCT AUTHOR_ID AS ID FROM VIEWS
WHERE AUTHOR_ID = VIEWER_ID
ORDER BY AUTHOR_ID;
--EX13
SELECT DISTINCT PART,ASSEMBLY_STEP FROM parts_assembly
WHERE FINISH_DATE IS NULL;
--EX14
select * from lyft_drivers
WHERE YEARLY <= 30000 OR YEARLY >=70000;
--EX15
select ADVERTISING_CHANNEL from uber_advertising
WHERE MONEY_SPENT > 100000;



