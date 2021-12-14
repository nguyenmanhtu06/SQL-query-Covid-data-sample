select * from ASEANinfo
order by location, date;
-- count columns
SELECT COUNT(COLUMN_NAME) 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_CATALOG = 'Covid Project' 
    AND TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'ASEANinfo'

--replace NULL values with N/A
select location, date,
ISNULL(total_deaths,'N/A') total_deaths
from ASEANinfo
order by location, date;
--alternative way
select location, date,
case 
when total_deaths is null then 'N/A'
else total_deaths
end
from ASEANinfo

--remove unnecessary time in date column
update ASEANinfo
set date = CONVERT(date,date)

--alternative way
alter table ASEANinfo
add DateConverted date;

update ASEANinfo
set DateConverted = convert(date,date);
--then drop the old date column

--remove unused columns
alter table ASEANinfo
drop column reproduction_rate, stringency_index, median_age, extreme_poverty;
