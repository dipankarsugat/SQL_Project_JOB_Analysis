/* **Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.  */


select

count(jb.job_id) as job_total,
skills_dim.skills

from job_postings_fact as jb

left join skills_job_dim on jb.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where job_title like '%Data Analyst%' 
and
(job_location='Anywhere' or job_work_from_home = True)

group by skills_dim.skills
order by job_total DESC
limit 5;