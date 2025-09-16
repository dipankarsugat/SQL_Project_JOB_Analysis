/* **What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.
*/

with skilly as (

select

count(jb.job_id) as job_total, Round(avg(jb.salary_year_avg)) as salary_year_avg,
skills_dim.skills

from job_postings_fact as jb

inner join skills_job_dim on jb.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where job_title like '%Data Analyst%' 
and  -- optional to filter for remote jobs
(job_location='Anywhere' or job_work_from_home = True)
AND
salary_year_avg is not null


group by skills_dim.skills)


select 
*
from skilly
order by skilly.salary_year_avg desc