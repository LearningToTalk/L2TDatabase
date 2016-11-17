--work in progress query to numerically code maternal education values

SELECT DISTINCT Education,
  (CASE
       WHEN Education LIKE 'Less Than High School%' THEN 1
       WHEN Education LIKE 'GED%' THEN 2
       WHEN Education LIKE 'High School Diploma%' THEN 3
       WHEN Education LIKE 'Some College (0% year%)' THEN 4
       WHEN Education LIKE 'Some College (1% year%)' THEN 4
       WHEN Education LIKE 'Some College%' THEN 5
       WHEN Education LIKE 'Trade School%' THEN 5
       WHEN Education LIKE '%Technical%' THEN 5
       WHEN Education LIKE 'College%' THEN 6
       WHEN Education LIKE 'Graduate%' THEN 7
       ELSE NULL
   END) AS EduScale,
  (CASE
       WHEN Education LIKE 'Less Than High School%' THEN 'Less Than High School'
       WHEN Education LIKE 'Some College (0% year%)' THEN 'Some College (<2 years)'
       WHEN Education LIKE 'Some College (1% year%)' THEN 'Some College (<2 years)'
       WHEN Education LIKE 'Some College%' THEN 'Some College (2+ years)'
       ELSE NULL
   END) AS EduCategory
FROM `Caregivers_Entry`
