-- Get the minimum and maximum ages for study participants
create or replace algorithm = undefined view backend.q_Task_Ages_Summary as
  select
    ChildStudyID,
    min(taskage.Task_Age) as Task_Age_Min,
    max(taskage.Task_Age) as Task_Age_Max,
    max(taskage.Task_Age) - min(taskage.Task_Age) as Task_Age_Range
  from
    backend.q_Task_Ages taskage
  where
    -- Exclude LENA because those sometimes had hectic recording schedules
    Task != "LENA"
  group by
    ChildStudyID;

-- Get the minimum and maximum ages for study participants
create or replace algorithm = undefined view l2t.Task_Ages_Summary as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    tasksum.Task_Age_Min,
    tasksum.Task_Age_Max,
    tasksum.Task_Age_Range
  from
    backend.q_Task_Ages_Summary tasksum
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    Study,
    ResearchID;

-- Get the ages for each task with the research IDs and study names
create or replace algorithm = undefined view l2t.Task_Ages as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    taskage.Task,
    taskage.Task_Age,
    taskage.Task_Completion
  from
    backend.q_Task_Ages taskage
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    Study,
    ResearchID,
    Task;


