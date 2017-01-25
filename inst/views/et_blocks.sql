-- Create queries for the eyetracking database.
-- Switch ALTER to CREATE to create the views anew. Otherwise, use ALTER to
-- update the views.

create or replace algorithm = undefined view eyetracking.q_BlocksByStudy as
  select
    d.Study,
    c.ShortResearchID as ResearchID,
    a.Block_Task as Task,
    a.Block_Version as Version,
    a.Block_Basename as Basename,
    a.Block_DateTime as DateTime,
    a.Block_Age as Block_Age,
    a.BlockID as BlockID
  from
    eyetracking.Blocks a
    left join backend.ChildStudy c
      using (ChildStudyID)
    left join backend.Study d
      using (StudyID)
  order by
    a.Block_Basename;


create or replace algorithm = undefined view eyetracking.q_BlockAttributesByStudy as
  select
    a.Study,
    a.ResearchID,
    a.Task,
    a.Version,
    a.Basename,
    a.DateTime,
    a.BlockID,
    b.BlockAttribute_Name,
    b.BlockAttribute_Value
  from
    eyetracking.q_BlocksByStudy a
    left join eyetracking.BlockAttributes b
      using (BlockID)
  order by
    a.Basename;


create or replace algorithm = undefined view eyetracking.q_TrialsByStudy as
  select
    a.Study,
    a.ResearchID,
    a.Task,
    a.Version,
    a.Basename,
    a.DateTime,
    a.BlockID,
    b.TrialID,
    b.Trial_TrialNo as TrialNo
  from
    eyetracking.q_BlocksByStudy a
    left join eyetracking.Trials b
      using (BlockID)
  order by
    a.Basename,
    b.Trial_TrialNo;


create or replace algorithm = undefined view eyetracking.q_TrialAttributesByStudy as
  select
    a.Study,
    a.ResearchID,
    a.Task,
    a.Version,
    a.Basename,
    a.DateTime,
    a.BlockID,
    b.TrialID,
    a.TrialNo,
    b.TrialAttribute_Name,
    b.TrialAttribute_Value
  from
    eyetracking.q_TrialsByStudy a
    left join eyetracking.TrialAttributes b
      using (TrialID)
  order by
    a.Basename,
    a.TrialNo,
    b.TrialAttribute_Name;


create or replace algorithm = undefined view eyetracking.q_LooksByStudy as
  select
    a.Study,
    a.ResearchID,
    a.Task,
    a.Version,
    a.Basename,
    a.DateTime,
    a.BlockID,
    b.TrialID,
    a.TrialNo,
    b.Time,
    b.XMean,
    b.YMean,
    b.GazeByImageAOI,
    b.GazeByAOI
  from
    eyetracking.q_TrialsByStudy a
    left join eyetracking.Looks b
      using (TrialID)
  order by
    a.Basename,
    a.TrialNo,
    b.Time;


-- count(A) returns number of non-NULL values in A.
-- count(*) returns number of records (rows).
-- 1 - (count(A) / count(*)) therefore is proportion of NULLs in A.
create or replace algorithm = undefined view eyetracking.q_MissingDataByBlock as
  select
    Study,
    ResearchID,
    Task,
    Version,
    Basename,
    DateTime,
    BlockID,
    0 as MissingDataWindow_Start,
    2000 as MissingDataWindow_End,
    (1 - count(GazeByImageAOI) / count(*)) as ProportionMissing
  from
    eyetracking.q_LooksByStudy
  where
    Time between 0 and 2000
  group by
    BlockID
  order by
    Study,
    ResearchID,
    Task,
    Basename;
