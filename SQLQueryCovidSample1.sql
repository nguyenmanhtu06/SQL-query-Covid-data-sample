-- Create a table for ASEAN countries
Select * 
into ASEANinfo  from  Global
where continent = 'Asia'
and location = 'Vietnam'
or location = 'Brunei'
or location = 'Cambodia'
or location = 'Indonesia'
or location = 'Laos'
or location = 'Malaysia'
or location = 'Myanmar'
or location = 'Philippines'
or location = 'Singapore'
or location = 'Thailand';


-- Calculate total death counts, total cases and percentages of death and infected cases

select location, max(total_deaths) as [total death], max(total_cases) as [total cases], 
max(total_deaths/population)*100 as [death percentages], max(total_cases/population)*100 as [infected percentages]
from ASEANinfo
group by location, population
order by location;
-- this query would return the wrong results, because the data types are wrong (messed up between numeric types). 
-- Thus it must be fixed as:

select location, max(cast(total_deaths as int)) as [total death], max(cast(total_cases as int)) as [total cases], 
max(total_deaths/population)*100 as [death percentages], max(total_cases/population)*100 as [infected percentages]
from ASEANinfo
group by location, population
order by location;

-- Vaccination status:

select location, population,
max(cast(total_cases as int)) as [total cases], 
max(cast(total_deaths as int)) as [total death], 
max(cast(total_vaccinations as int)) as [total vaccinations], 
max(cast(people_vaccinated as int)) as [people vaccinated], 
max(cast(people_fully_vaccinated as int)) as [people_fully_vaccinated],
(max(cast(people_vaccinated as int))/population*100) as vaccinated_percentages,
(max(cast(people_fully_vaccinated as int))/population*100) as fully_vaccinated_percentages,
(max(cast(total_deaths as int))/population*100) as death_percentages
from ASEANinfo
group by location, population;

-- Highest death counts
select location, population,
max(cast(total_deaths as int)) as [total death], 
(max(cast(total_deaths as int))/population*100) as death_percentages
from ASEANinfo
group by location, population
order by max(cast(total_deaths as int)) desc;

-- Highest death percentages
select location, population,
max(cast(total_deaths as int)) as [total death], 
(max(cast(total_deaths as int))/population*100) as death_percentages
from ASEANinfo
group by location, population
order by (max(cast(total_deaths as int))/population*100) desc;

-- create a table for East Asia region
select *
into EastAsiainfo
from Global
where continent = 'Asia'
and location = 'China'
or location = 'Japan'
or location = 'Mongolia'
or location = 'South Korea'
or location = 'Taiwan';


--checking the information of the table

EXEC sp_help EastAsiainfo;

-- average death per day
select location, avg(cast(new_deaths as int)) as average_death_per_day
from EastAsiainfo ea
group by location
order by avg(cast(new_deaths as int)) desc;

-- perform union between EastAsiainfo table and ASEAN info table

select ea.location
from EastAsiainfo as ea
union
select sea.location
from ASEANinfo as sea
order by location;

-- compare total deaths, total cases and vaccination status

select ea.location, ea.population, 
max(cast(ea.total_deaths as bigint)) as total_death, max(cast(ea.total_vaccinations as bigint)) as total_vaxxed,
max(cast(ea.people_vaccinated as bigint)) as [people vaccinated], 
max(cast(ea.people_fully_vaccinated as bigint)) as [people_fully_vaccinated],
(max(cast(ea.people_vaccinated as bigint))/population*100) as vaccinated_percentages,
(max(cast(ea.people_fully_vaccinated as bigint))/population*100) as fully_vaccinated_percentages,
(max(cast(ea.total_deaths as bigint))/population*100) as death_percentages
from EastAsiainfo as ea
group by ea.location, ea.population
union
select sea.location, sea.population, 
max(cast(sea.total_deaths as bigint)) as total_death, max(cast(sea.total_vaccinations as bigint)) as total_vaxxed,
max(cast(sea.people_vaccinated as bigint)) as [people vaccinated], 
max(cast(sea.people_fully_vaccinated as bigint)) as [people_fully_vaccinated],
(max(cast(sea.people_vaccinated as bigint))/population*100) as vaccinated_percentages,
(max(cast(sea.people_fully_vaccinated as bigint))/population*100) as fully_vaccinated_percentages,
(max(cast(sea.total_deaths as bigint))/population*100) as death_percentages
from ASEANinfo as sea
group by sea.location, sea.population;