# Introduction 
Welcome to my SQL portfolio project focused on the Data Analyst job market!
The purpose of this project is to answer real job-seeker questions:

What are the best-paid Data Analyst roles?

Which skills should I focus on to maximize both my employability and my salary?

I use SQL to analyze a large, realistic dataset of job postings, and extract meaningful, actionable insights for anyone entering or growing in the field of data analytics.

[project_sql](/project_sql/)


# Background

As someone preparing for a career in data analytics, I wanted to dig deeper than just job titles.
My goals were:

To find out which remote Data Analyst jobs pay the most

To understand which skills are most demanded and best paid in the current market

To combine salary and demand, finding the “optimal” skills for career growth


### Key Questions I Set Out to Answer:

1.What are the top-paying remote Data Analyst jobs?

2.What skills are required for those top-paying jobs?

3.Which skills are in highest demand for Data Analyst roles?

4.Which skills are linked to the highest average salaries?

5.What are the most optimal skills to learn (high demand & high salary)?


# Tools Used

-**SQL** (PostgreSQL): For all data exploration, analysis, and aggregation.

-**Visual Studio Code**: For writing and running SQL queries and managing the project.

# The Analysis & Queries
Below, I explain how each query was built, what it’s meant to answer, and why it matters for anyone in data analytics:

### 1. Top-Paying Data Analyst Jobs

Identifies the highest-paying remote Data Analyst roles, focusing on jobs with specified salaries.
```SQL
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
```

### 2.Top-Paying Jobs & Required Skills

Adds required skills for each of the top-paying jobs.

Without CTE:
```sql
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
```
With CTE:
```sql
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
  order by salary_year_avg desc
limit 10
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
WHERE skills_dim.skills IS NOT NULL
ORDER BY data_analyst_jobs.salary_year_avg DESC
limit 10;
```
### 3. Most In-Demand Skills for Data Analysts

Which skills appear in the most job postings?
```sql
select

count(jb.job_id) as job_total,
skills_dim.skills

from job_postings_fact as jb

inner join skills_job_dim on jb.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id

where job_title like '%Data Analyst%' 
and
(job_location='Anywhere' or job_work_from_home = True)

group by skills_dim.skills
order by job_total DESC
limit 5;
```

### 4. Top Skills by Average Salary

Ranks each skill by its average salary (for jobs where salary info is available).

```sql
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


)


select 
*
from skilly
order by salary_year_avg desc;
```

### 5. Most Optimal Skills: High Demand + High Salary

Ranks skills by both demand and average salary—so you know what skills are most “worth it”.

```sql
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
```

# What I learned ?

-**Advanced SQL: Using CTEs**, multi-table joins, aggregation, and subqueries.

-**Data storytelling**: Turning raw job data into actionable, real-world advice.

-**Understanding the market**: Seeing how demand and salary can (sometimes) point to different “best” skills.

# Insights

-SQL and Python are both highly paid and in-demand—no surprise!

-Some niche tools/skills pay very well, but only a few jobs want them.

-The best bet? Learn what’s both popular and high paying.

### Conclusion

This project helped me level up my SQL and analytical thinking while learning exactly what to focus on as a Data Analyst.
If you want to break into analytics, focus on the skills that show up at the top of both the “demand” and “salary” lists!