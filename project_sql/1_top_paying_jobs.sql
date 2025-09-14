/*  **Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility. */



select
job_id,job_title, 
job_location, 
job_schedule_type, 
job_work_from_home, 
salary_year_avg, 
job_posted_date,
company_dim.name


from job_postings_fact

left join company_dim on job_postings_fact.company_id=company_dim.company_id -- optional if you want to fetch company name from the company_id

where 
job_title like '%Data Analyst%' 
and
(job_location='Anywhere' or job_work_from_home = True)
and 
salary_year_avg is not null

order by salary_year_avg desc
limit 10;



