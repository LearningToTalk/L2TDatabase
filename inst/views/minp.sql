-- Create a view to display the proportion correct for non-training trials in
-- each administration of the Minimal Pairs experiment.
create or replace algorithm = undefined view backend.q_MinPair_Aggregate as
  select
    childstudy.ChildStudyID,
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    minp_admin.MinPairID,
    minp_admin.MinPair_EprimeFile,
    minp_admin.MinPair_Dialect,
    minp_admin.MinPair_Completion,
    minp_admin.MinPair_Age,
    count(case minp_resp.Running when "Test" then 1 else null end) as `MinPair_NumTestTrials`,
    round(avg(minp_resp.Correct), 4.0) as `MinPair_ProportionCorrect`
  from
    backend.ChildStudy childstudy
    left join backend.Study study
      using (StudyID)
    left join backend.MinPair_Admin minp_admin
      using (ChildStudyID)
    left join backend.MinPair_Responses minp_resp
      using (MinPairID)
  where
    minp_resp.Running = "Test"
  group by
    minp_admin.MinPairID
  order by
    minp_admin.MinPairID;


-- User-facing version
create or replace algorithm = undefined view l2t.MinPair_Aggregate as
  select
    Study,
    ResearchID,
    MinPair_EprimeFile,
    MinPair_Dialect,
    MinPair_Completion,
    MinPair_Age,
    MinPair_NumTestTrials,
    MinPair_ProportionCorrect
  from
    backend.q_MinPair_Aggregate
  order by
    Study,
    ResearchID;


-- Create a view to display trial-level data.
create or replace algorithm = undefined view l2t.MinPair_Trials as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    minp_admin.MinPair_EprimeFile,
    minp_admin.MinPair_Dialect,
    minp_admin.MinPair_Completion,
    minp_admin.MinPair_Age,
    minp_resp.Running as MinPair_TrialType,
    minp_resp.Trial as MinPair_Trial,
    minp_resp.Item1 as MinPair_Item1,
    minp_resp.Item2 as MinPair_Item2,
    minp_resp.ImageSide as MinPair_ImageSide,
    minp_resp.CorrectResponse as MinPair_TargetItem,
    minp_resp.Correct as MinPair_Correct
  from
    backend.MinPair_Admin minp_admin
    left join backend.MinPair_Responses minp_resp
      using (MinPairID)
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID,
    minp_admin.MinPair_Dialect,
    minp_admin.MinPair_Completion,
    minp_resp.Running,
    minp_resp.Trial;

