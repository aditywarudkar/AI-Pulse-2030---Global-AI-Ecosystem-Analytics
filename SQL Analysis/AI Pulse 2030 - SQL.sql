---TABLE ONE CREATED ----

CREATE TABLE job (
    Employee_ID TEXT,
    Job_Title TEXT,
    Industry TEXT,
    Country TEXT,
    Education_Level TEXT,
    Years_Experience NUMERIC(10,1),
    AI_Replacement_Risk NUMERIC(10,1),
    Future_Demand_Score NUMERIC(10,1),
    Remote_Work_Possibility TEXT,
    Average_Salary_USD NUMERIC(12,2),
    Required_Skills TEXT,
    Automation_Level TEXT,
    Job_Growth_2030 NUMERIC(10,1),
    Work_Hours_Per_Week NUMERIC(10,1),
    Company_Size TEXT,
    AI_Tool_Usage TEXT,
    Performance_Score NUMERIC(10,1),
    Upskilling_Needed TEXT,
    Job_Satisfaction NUMERIC(10,1),
    Hiring_Trend_2026 TEXT);

--- TABLE TW0 CREATED STUDENTS---

	CREATE TABLE students(
	Student_ID TEXT,
	Major_Category	TEXT,
	Year_of_Study TEXT,
	Pre_Semester_GPA	TEXT,
	Weekly_GenAI_Hours NUMERIC(10,1),
	Primary_Use_Case TEXT,
	Prompt_Engineering_Skill TEXT,
	Tool_Diversity	NUMERIC(10,2),
	Paid_Subscription TEXT,
	Traditional_Study_Hours NUMERIC(10,1),
	Perceived_AI_Dependency NUMERIC(10,1),
	Institutional_Policy TEXT,
	Anxiety_Level_During_Exams	NUMERIC(10,1),
	Post_Semester_GPA NUMERIC(10,1),
	Skill_Retention_Score	NUMERIC(10,1),
	Burnout_Risk_Level TEXT);

CREATE TABLE ai_tools(
	Tool_Name TEXT,
	Website_URL TEXT,
	Domain_	TEXT,
	Domain_Extension TEXT,
	Domain_Length	NUMERIC(10,1),
	Description TEXT,
	Description_Word_Count NUMERIC(10,1),
	Tags	TEXT,
	Category TEXT,
	Subcategory TEXT,
	Is_Open_Source	TEXT,
	GitHub_Stars NUMERIC(10,1),
	GitHub_Forks NUMERIC(10,1),
	Primary_Language	TEXT,
	GitHub_Open_Issues NUMERIC(10,1));

	select * from job;
	SELECT * FROM students;
	select * from ai_tools;

	

--- !! BUSSINESS INSIGHTS OF JOB DATASET !! ---

----1. Which industries have the highest average salary?
                                                                       
	SELECT industry, ROUND(AVG(Average_Salary_USD),2) AS Avg_Salary
	FROM job
	GROUP BY INDUSTRY
	ORDER BY Avg_Salary DESC;

----2. Which countries have the highest AI job demand?

	SELECT Country,ROUND(AVG(Future_Demand_Score),2) AS DEMAND_SCORE ---WE USED "AVG" NOT "MAX" || HIGHEST VALUE = MAX,OVERAL TREND = AVG
	FROM job
	GROUP BY Country
	ORDER BY DEMAND_SCORE DESC;
	
---3. Which job titles have the highest AI replacement risk?

	SELECT Job_Title, ROUND(AVG(AI_Replacement_Risk),2) AS risk
	FROM job
	GROUP BY Job_Title
	ORDER BY risk DESC;

---4. Average salary by education level?

	SELECT Education_Level, ROUND(AVG(Average_Salary_USD),2) AS Avg_salary
	FROM job
	GROUP BY Education_Level
	ORDER BY Avg_salary DESC;

---5. Average future demand by industry

	SELECT Industry, ROUND(AVG(Future_Demand_Score)) AS Future_Demand
	FROM job
	GROUP BY Industry
	ORDER BY Future_Demand DESC;

---6. How can jobs be classified into High, Medium, and Low salary categories to help job seekers identify high-paying career opportunities?

	SELECT Job_Title,
       Average_Salary_USD,
       CASE
            WHEN Average_Salary_USD >= 120000 THEN 'High Salary'
            WHEN Average_Salary_USD >= 70000 THEN 'Medium Salary'
            ELSE 'Low Salary'
       END AS Salary_Category
	FROM job;

---7. Which industries have the highest number of jobs with strong future demand (Future Demand Score > 80)?

		WITH High_Demand_Jobs AS
	(
	    SELECT *
	    FROM job
	    WHERE Future_Demand_Score > 80
	)
	
	SELECT Industry,
	       COUNT(*) AS Total_High_Demand_Jobs
	FROM High_Demand_Jobs
	GROUP BY Industry
	ORDER BY Total_High_Demand_Jobs DESC;

---8. How do industries rank based on their average salary?

	SELECT Industry,
       ROUND(AVG(Average_Salary_USD),2) AS Avg_Salary,
       RANK() OVER(ORDER BY AVG(Average_Salary_USD) DESC) AS Salary_Rank
	FROM job
	GROUP BY Industry;

--- !! BUSSINESS INSIGHTS OF STUDENTS DATASET !! ---

---1. Which majors experience the greatest improvement in GPA after adopting Generative AI?

	SELECT Major_Category, 
	ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA::NUMERIC),2) AS greatest_improvement_GPA
	FROM students 
	GROUP BY Major_Category
	ORDER BY greatest_improvement_GPA DESC;

---2. Does higher AI dependency correspond to a higher level of burnout among students?

	SELECT Perceived_AI_Dependency,
       Burnout_Risk_Level,
       COUNT(*) AS Total_Students
	FROM students
	GROUP BY Perceived_AI_Dependency, Burnout_Risk_Level
	ORDER BY Perceived_AI_Dependency DESC;

---3. Which AI use case is most popular among students?

	SELECT 
	Primary_Use_Case, COUNT(Student_Id )AS most_popular
	FROM students
	GROUP BY Primary_Use_Case
	ORDER BY most_popular DESC;

---4.Which majors have the highest number of students with High burnout risk?

	SELECT Major_Category,
       COUNT(Student_ID) AS Total_Students
	FROM Students
	WHERE Burnout_Risk_Level = 'High'
	GROUP BY Major_Category
	ORDER BY Total_Students DESC;

---5. Do paid AI subscribers have a higher average GPA than free users?

	SELECT Paid_Subscription,
       ROUND(AVG(Post_Semester_GPA),2) AS Avg_GPA
	FROM students
	GROUP BY Paid_Subscription
	ORDER BY Avg_GPA DESC;

---6. How can students be categorized based on their perceived AI dependency?

	SELECT Student_ID,
       Perceived_AI_Dependency,
       CASE
            WHEN Perceived_AI_Dependency >=8 THEN 'High'
            WHEN Perceived_AI_Dependency >=5 THEN 'Medium'
            ELSE 'Low'
       END AS Dependency_Level
	FROM students;

---7. Which majors have the highest number of students whose GPA improved by more than 1 point after using Generative AI?
	
		WITH GPA_Improvement AS
	(
	    SELECT *,
	           (Post_Semester_GPA - Pre_Semester_GPA::NUMERIC) AS Improvement
	    FROM students
	)
	
	SELECT Major_Category,
	       COUNT(*) AS Total_Students
	FROM GPA_Improvement
	WHERE Improvement > 1
	GROUP BY Major_Category
	ORDER BY Total_Students DESC;

---8.How do different majors rank based on average GPA improvement after adopting Generative AI?

	SELECT Major_Category,
	       ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA::NUMERIC),2) AS GPA_Improvement,
	       RANK() OVER(
	           ORDER BY AVG(Post_Semester_GPA - Pre_Semester_GPA::NUMERIC) DESC
	       ) AS Improvement_Rank
	FROM students
	GROUP BY Major_Category;
	
--- !! BUSSINESS INSIGHTS OF AI TOOLS DATASET !! ---

---1. Which AI category has the highest average GitHub stars?

	SELECT Category,
       ROUND(AVG(GitHub_Stars),2) AS Avg_GitHub_Stars
	FROM ai_tools
	GROUP BY Category
	ORDER BY Avg_GitHub_Stars DESC;

---2. Do open-source AI tools receive more community support than closed-source tools?
	
	SELECT Is_Open_Source,
       ROUND(AVG(GitHub_Stars),2) AS Avg_Stars,
       ROUND(AVG(GitHub_Forks),2) AS Avg_Forks
	FROM ai_tools
	GROUP BY Is_Open_Source;

---3. Which programming language is used to build the most AI tools?

	SELECT Primary_Language,
       COUNT(Tool_Name) AS Total_Tools
	FROM ai_tools
	GROUP BY Primary_Language
	ORDER BY Total_Tools DESC;

---4. Which AI category has the strongest developer community?

	SELECT Category,
       SUM(GitHub_Stars) AS Total_Stars,
       SUM(GitHub_Forks) AS Total_Forks
	FROM ai_tools
	GROUP BY Category
	ORDER BY Total_Stars DESC, Total_Forks DESC;

---5. Which AI tools can be considered "Hidden Gems" (high stars but low forks)?

	SELECT Tool_Name,
	       GitHub_Stars,
	       GitHub_Forks
	FROM ai_tools
	WHERE GitHub_Stars > (
	    SELECT AVG(GitHub_Stars)
	    FROM ai_tools
	)
	AND GitHub_Forks < (
	    SELECT AVG(GitHub_Forks)
	    FROM ai_tools
	)
	ORDER BY GitHub_Stars DESC;

---6. How can AI tools be categorized into High, Medium, and Low popularity based on GitHub stars?
	
	SELECT Tool_Name,
       GitHub_Stars,
       CASE
           WHEN GitHub_Stars >= 10000 THEN 'Highly Popular'
           WHEN GitHub_Stars >= 5000 THEN 'Moderately Popular'
           ELSE 'Less Popular'
       END AS Popularity
	FROM ai_tools;

---7. Which AI categories contain the highest number of tools with above-average GitHub stars?
	
		WITH Popular_Tools AS
	(
	    SELECT *
	    FROM ai_tools
	    WHERE GitHub_Stars >
	    (
	        SELECT AVG(GitHub_Stars)
	        FROM ai_tools
	    )
	)
	
	SELECT Category,
	       COUNT(*) AS Total_Tools
	FROM Popular_Tools
	GROUP BY Category
	ORDER BY Total_Tools DESC;

---8. Rank AI tools within each category based on GitHub stars.
	
	SELECT Category,
	       Tool_Name,
	       GitHub_Stars,
	       RANK() OVER(
	           PARTITION BY Category
	           ORDER BY GitHub_Stars DESC
	       ) AS Tool_Rank
	FROM ai_tools;

