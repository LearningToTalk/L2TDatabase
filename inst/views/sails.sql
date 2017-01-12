-- Create a view to display the proportion correct for non-training trials in
-- each administration of the SAILS experiment.
create or replace algorithm = undefined view backend.q_SAILS_PropCorrect as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.SAILSID,
    b.SAILS_EprimeFile,
    b.SAILS_Completion,
    b.SAILS_Dialect,
    b.SAILS_Age,
    round(avg(a.Correct), 4.0) as `SAILS_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.SAILS_Admin b
      using (ChildStudyID)
    left join backend.SAILS_Responses a
      using (SAILSID)
  where
    a.Running = "Test"
  group by
    b.SAILSID
  order by
    c.Study,
    d.ShortResearchID;


-- Create a view to display the proportion correct for non-training trials in
-- each administration of the SAILS experiment, along with counts of training
-- and non-training trials.
create or replace algorithm = undefined view backend.q_SAILS_Aggregate as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.SAILS_EprimeFile,
    b.SAILS_Completion,
    b.SAILS_Age,
    b.SAILS_Dialect,
    count(case a.Running when "Familiarization" then 1 else null end) as `SAILS_NumPracticeTrials`,
    count(case a.Running when "Test" then 1 else null end) as `SAILS_NumTestTrials`,
    p.SAILS_ProportionCorrect as `SAILS_ProportionTestCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.SAILS_Admin b
      using (ChildStudyID)
    left join backend.SAILS_Responses a
      using (SAILSID)
    left join backend.q_SAILS_PropCorrect p
      using (SAILSID)
  where
    b.SAILS_Completion is not null
  group by
    b.SAILSID
  order by
    c.Study,
    d.ShortResearchID;



-- Create a view to display the proportion correct for non-training trials in
-- each administration of the SAILS experiment, along with counts of training
-- and non-training trials.
create or replace algorithm = undefined view l2t.SAILS_Aggregate as
  select
    Study,
    ResearchID,
    SAILS_EprimeFile,
    SAILS_Completion,
    SAILS_Age,
    SAILS_Dialect,
    SAILS_NumPracticeTrials,
    SAILS_NumTestTrials,
    SAILS_ProportionTestCorrect
  from
    backend.q_SAILS_Aggregate
  order by
    Study,
    ResearchID;




-- Create a view to display the proportion correct for non-training trials in
-- each module of each administration of the SAILS experiment.
create or replace algorithm = undefined view l2t.SAILS_Module_Aggregate as
  select
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.SAILS_EprimeFile,
    b.SAILS_Completion,
    b.SAILS_Dialect,
    b.SAILS_Age,
    a.Module as `SAILS_Module`,
    count(case a.Running when "Test" then 1 else null end) as `SAILS_Module_NumTestTrials`,
    round(avg(a.Correct), 4.0) as `SAILS_Module_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.SAILS_Admin b
      using (ChildStudyID)
    left join backend.SAILS_Responses a
      using (SAILSID)
  where
    a.Running = "Test"
  group by
    b.SAILSID,
    a.Module
  order by
    c.Study,
    d.ShortResearchID,
    a.Module;




