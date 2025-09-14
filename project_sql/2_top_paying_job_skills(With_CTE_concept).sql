 /* **Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries
*/

WITH data_analyst_jobs AS (
  SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type,
    job_postings_fact.job_work_from_home,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date,
    company_dim.name

  FROM job_postings_fact
  
  left join company_dim on job_postings_fact.company_id=company_dim.company_id -- optional if you want to fetch company name from the company_id
  WHERE job_title LIKE '%Data Analyst%'
    AND (job_location = 'Anywhere' OR job_work_from_home = TRUE)
    AND salary_year_avg IS NOT NULL
)

 
select 
  data_analyst_jobs.job_id,
    data_analyst_jobs.job_title,
    data_analyst_jobs.job_location,
    data_analyst_jobs.job_schedule_type,
    data_analyst_jobs.job_work_from_home,
    data_analyst_jobs.salary_year_avg,
    data_analyst_jobs.job_posted_date,
    data_analyst_jobs.name,
    skills_dim.skills

from skills_job_dim

inner join data_analyst_jobs on skills_job_dim.job_id=data_analyst_jobs.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
ORDER BY data_analyst_jobs.salary_year_avg DESC
LIMIT 10;


