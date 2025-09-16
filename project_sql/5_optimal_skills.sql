/* **What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis */


with skilly as (

select

count(jb.job_id) as job_total, Round(avg(jb.salary_year_avg),0) as salary_year_avg,
skills_dim.skills

from job_postings_fact as jb

inner join skills_job_dim on jb.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where job_title like '%Data Analyst%' 
and  -- optional to filter for remote jobs
(job_location='Anywhere' or job_work_from_home = True)
AND
salary_year_avg is not null


group by skills_dim.skills
order by job_total DESC
limit 50
)


select 
*
from skilly
order by skilly.salary_year_avg desc