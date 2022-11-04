SELECT 
    *
FROM
    covid.coviddeaths;
    
#selecting the data I would be working with#
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid.coviddeaths
    order by 1,2;
    
#Looking at total deaths vs total cases#
#shows likelihood of dying if you contract covid in a particular location#
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS Death_Percentage
FROM
    covid.coviddeaths
    where location = 'India'
    order by location;
    
#total cases vs population#
#calculating infection percentage#
SELECT 
    location,
    date,
    total_cases,
    population,
    (total_cases/population)*100 AS Infection_Percentage
FROM
    covid.coviddeaths
    where location = 'India'
    order by infection_percentage desc;
    
    #Finding out which location had the highest infection percentage compared to population#
SELECT 
    location,
    total_cases,
    population,
    (total_cases/population)*100 AS Infection_Percentage
FROM
    covid.coviddeaths
    order by infection_percentage desc;

#finding out highest infection count location wise#
SELECT 
    location,
    max((total_cases)) as Infection_Count,
    population,
    max((total_cases/population))*100 AS Infection_Percentage
FROM
    covid.coviddeaths
    group by location
    order by Infection_Percentage desc;
    
    #finding locations with highest death count per population#
 SELECT 
    location,
    max(total_deaths) as Death_Count,
    population,
    max(total_deaths/population)*100 AS Death_Percentage
FROM
    covid.coviddeaths
    group by location
    order by Death_Percentage desc;   
    
    #breaking things up by continent#
  SELECT 
    continent,
    max(total_deaths) as Death_Count,
    population,
    max(total_deaths/population)*100 AS Death_Percentage
FROM
    covid.coviddeaths
    group by continent
    order by Death_Percentage desc;      
    
    #some more aggregrate functions#
 SELECT 
    location,
    sum(new_deaths) as total_deaths,
    sum(new_cases) as total_cases,
    sum(new_deaths)/sum(new_cases)*100 as death_percentage
FROM
    covid.coviddeaths
    group by location;      
