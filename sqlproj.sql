select *
from layoffs;

create table layoff_stage2
like layoffs;

select *
from layoff_stage;

insert  layoff_stage
select *
from layoffs;

-- create cte_dublicates
with cte_dublicate as 
(select *,
row_number() over( 
partition by ï»؟company,location , industry ,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as Row_num
from layoffs )

select *
from cte_dublicate 
where Row_num >1;

select  *
from layoffs
where ï»؟company ='Oda';

with cte_remove as 
(select *,
row_number() over( 
partition by ï»؟company,location , industry ,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs )

delete 
from cte_remove
where Row_num >1;

create table stage2
like layoff_stage;

alter table stage2
add column row_num int;

insert into stage2(
select *,
row_number() over( 
partition by ï»؟company,location , industry ,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
from layoffs);

select *
from stage2
where row_num > 1;

SET SQL_SAFE_UPDATES = 0;

delete from stage2
where row_num >1;
-- now all dublicate values deleted
SET SQL_SAFE_UPDATES = 1;


-- standardizing data 
alter table stage2
rename column ï»؟company TO company ;

select  company, trim(company) as trim_company
from stage2;

SET SQL_SAFE_UPDATES = 0;

update  stage2
set company = trim(company);

select  distinct industry 
from stage2
order by 1 ;

select  industry 
from stage2
where industry is null or industry = ' ';


select *
from stage2
where industry like 'crypto%';


update stage2
set industry = 'Crypto'
where industry like 'crypto%';

select  * 
from stage2
where company like 'Airbnb' and total_laid_off = 30 ;

update stage2
set industry = null
where company like 'Airbnb' and total_laid_off = 30 ;

select distinct country
from stage2
order by 1;

update stage2
set country = 'United States'
where country like 'United States%';

-- or can use trailing to remove comma 

select distinct trim(trailing '.' from country)
from stage2
order by 1;

select `date` 
from stage2;

update stage2
set `date`= str_to_date(`date`,'%m/%d/%Y');

-- date feild still as text so we gonna convert it

alter table stage2
modify column `date` date; 

select *
from stage2
where total_laid_off is null and percentage_laid_off is null;


select *
from stage2
where company = 'Airbnb';

select *
from stage2 as st2
join stage2 as st3
	on st2.company = st3.company
    and st2.location = st3.location
where (st2.industry is null or st2.industry ='') and st3.industry is not null;

select st2.industry , st2.location , st3.industry,st3.location
from stage2 as st2
join stage2 as st3
	on st2.company = st3.company
    and st2.location = st3.location
where (st2.industry is null or st2.industry ='') and st3.industry is not null;

set SQL_SAFE_UPDATES = 0;

update stage2 as st2
join stage2 as st3
	on st2.company = st3.company
    and st2.location = st3.location
set st2.industry = st3.industry
where (st2.industry is null or st2.industry ='') and st3.industry is not null;

-- so we change just null values not the blank values so we're gonna change it 

update stage2
set industry = null 
where industry = ''; 

select *
from stage2
where company like'Bally%';

update stage2 as st2
join stage2 as st3
	on st2.company = st3.company
    and st2.location = st3.location
set st2.industry = st3.industry
where (st2.industry is null or st2.industry ='') and st3.industry is not null;
-- now it's working 
-- ther's one company 'Bally''s Interactive' doesn't have industry name 

select *
from stage2
where company like'Airbnb%';

delete 
from stage2
where total_laid_off is null and percentage_laid_off is null and funds_raised_millions is null ;

delete 
from stage2
where total_laid_off is null and percentage_laid_off is null ;

-- now let's delete unwanted column 

select *
from stage2 ;

alter table stage2
drop column row_num;

-- explaratory Data 

-- show the top company based on sum of laid_off
select company , sum(total_laid_off)
from stage2
group by company
order by 2 desc;

-- show minimun and maximum date of the data 
select min(`date`),max(`date`)
from stage2;
-- show the top industry based on sum of laid_off
select industry, sum(total_laid_off)
from stage2
group by industry
order by 2 desc;

-- show the top company based on sum of laid_off  and country
select country, sum(total_laid_off)
from stage2
group by country
order by 2 desc;

-- show what's the total liad off based on each year
select year(`date`), sum(total_laid_off)
from stage2
group by  year(`date`)
order by 1,2 desc;

-- show what's the total liad off based on each year and month
select year(`date`) as `year`,month(`date`) as `month`, sum(total_laid_off) as total_per_month
from stage2
group by year(`date`) ,month(`date`)
order by 1,2,3 desc;

-- crate CTE that show rolling total based on Date 
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM stage2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off ,SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

-- show the Ranking company and Year based on sum of laid_off 
select company , year(`date`) , sum(total_laid_off),rank()over(partition by year(`date`))
from stage2
group by company , year(`date`) 
order by 1;

-- create CTE show top comapny and ranking it 
with company_year as 
(
select company , year(`date`) as `Year` , sum(total_laid_off) as total_laid
from stage2
group by company , year(`date`) 
order by 3 desc
),
Company_Year_Rank AS
(
select *, dense_rank() over (partition by `Year` order by total_laid desc) as `Rank`
from company_year
where `Year` is not null
order by `Rank`)


select *
from Company_Year_Rank
where `Rank` <=5
