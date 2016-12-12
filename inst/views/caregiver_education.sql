--Assign a numerical code for caregiver education levels

create algorithm = undefined view  `q_Household_Education` as
  select
    cg.HouseholdID,
    cg.CaregiverID,
    cg.Caregiver_Relation,
    (case
       when cg.Caregiver_Education like 'Less Than High School%' then 1
       when cg.Caregiver_Education like 'GED%' then 2
       when cg.Caregiver_Education like 'High School Diploma%' then 3
       when cg.Caregiver_Education like 'Some College (0% year%)' then 4
       when cg.Caregiver_Education like 'Some College (1% year%)' then 4
       when cg.Caregiver_Education like 'Some College%' then 5
       when cg.Caregiver_Education like 'Trade School%' then 5
       when cg.Caregiver_Education like '%Technical%' then 5
       when cg.Caregiver_Education like 'College%' then 6
       when cg.Caregiver_Education like 'Graduate%' then 7
       else null
     end) as Caregiver_EduScale,
    (case
       when cg.Caregiver_Education like 'Less Than High School%' then 'Less Than High School'
       when cg.Caregiver_Education like 'Some College (0% year%)' then 'Some College (<2 years)'
       when cg.Caregiver_Education like 'Some College (1% year%)' then 'Some College (<2 years)'
       when cg.Caregiver_Education like 'Some College%' then 'Some College (2+ years)'
       when cg.Caregiver_Education like 'NA' then null
       else cg.Caregiver_Education
     end) as Caregiver_EduCategory
  from
    Caregiver cg
  order by
    cg.HouseholdID,
    cg.Caregiver_Relation,
    Caregiver_EduScale,
    Caregiver_EduCategory




-- Helper subquery to get the maternal educations in each household
create algorithm = undefined view `q_Household_Maternal_Caregiver` as
  select *
  from q_Household_Education
  where
    Caregiver_Relation in ("Mother", "Grandmother (primary caregiver)") and
    Caregiver_EduScale is not null
  order by
    HouseholdID,
    Caregiver_EduScale desc



-- Max maternal education attainment per household.
--
-- We can't use subqueries when making a view, so we use this trick to get the
-- highest maternal education in each household
-- http://stackoverflow.com/a/28090544/1084259
create algorithm = undefined view `q_Household_Max_Maternal_Education` as
  select
    m.*
  from
    q_Household_Maternal_Caregiver m
  left join q_Household_Maternal_Caregiver b
    on m.HouseholdID = b.HouseholdID
      -- have only rows where table m < table b
      and (m.Caregiver_EduScale < b.Caregiver_EduScale
             -- break ties by using caregiver id
             or (m.Caregiver_EduScale = b.Caregiver_EduScale
               and m.CaregiverID < b.CaregiverID))
  where
    b.Caregiver_EduScale is null
  order by m.HouseholdID
