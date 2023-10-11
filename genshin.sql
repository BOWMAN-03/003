
--	--preview data
select * from genshin


	-- splitting gender+height off of the model column
DROP TABLE IF exists #gen_hei
CREATE TABLE #gen_hei
(model varchar(50),
gender varchar(50),
height varchar(50),
nation varchar(50))

INSERT INTO #gen_hei 
select model,
	case
	when model = 'medium male' then 'male'
	when model = 'tall male' then 'male'
	when model = 'tall female' then 'female'
	when model = 'medium female' then 'female'
	when model = 'short female' then 'female'
	end as gender,
	case
	when model = 'medium male' then 'medium'
	when model = 'tall male' then 'tall'
	when model = 'tall female' then 'tall'
	when model = 'medium female' then 'medium'
	when model = 'short female' then 'short'
	end as height,
	region
from genshin

	--get height from TEMP table
select nation, height, count(height) as people
from #gen_hei
where not nation = 'NA'
group by height, nation

	--get gender from TEMP table
select nation, gender, count(gender) as people
from #gen_hei
where not nation = 'NA'
group by gender, nation

	--get character attributes by nation (1 null exists as 'na' and was removed)
select avg(hp_90_90) as health, avg(atk_90_90) as attack, avg(def_90_90) as defense, region
from genshin
where not region = 'NA'
group by region


	--get common ascension boss
select region as nation, ascension_boss as enemy_boss, count(ascension_boss) as people
from Genshin
where not region = 'NA'
group by ascension_boss, region

	--get month of birthday (the birthday format is weird so it needs r.substring to id the month)
with CTE_bmonth as (Select region,
reverse(substring(reverse(birthday), 0,4))  as month
from genshin
)
select region, month, count(month) as people from CTE_bmonth
where not region = 'NA'
group by month, region


select birthday, character_name
from genshin

select count(region), region
from genshin
group by region