 /* **Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/



select
job_postings_fact.job_id, job_postings_fact.job_title, 
job_postings_fact.job_location, 
job_postings_fact.job_schedule_type, 
job_postings_fact.job_work_from_home, 
job_postings_fact.salary_year_avg, 
job_postings_fact.job_posted_date,
company_dim.name,
skills_dim.skills

from job_postings_fact

left join company_dim on job_postings_fact.company_id=company_dim.company_id -- optional if you want to fetch company name from the company_id
left join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
left join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where 
job_title like '%Data Analyst%' 
and
(job_location='Anywhere' or job_work_from_home = True)
and 
salary_year_avg is not null
and 
skills_dim.skills IS NOT NULL

order by salary_year_avg desc
limit 10;