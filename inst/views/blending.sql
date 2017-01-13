-- Create views to summarize the Blending experiment


-- Overall proportion correct
create or replace algorithm = undefined view backend.q_Blending_PropCorrect as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `Blending_TrialType`,
    sum(a.Administered) as `Blending_NumTrialsAdministered`,
    round(avg(a.Correct), 4.0) as  `Blending_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.Blending_Admin b
      using (ChildStudyID)
    left join backend.Blending_Responses a
      using (BlendingID)
  where
    b.Blending_Completion is not null
  group by
    b.BlendingID,
    a.Running
  order by
    c.Study,
    d.ShortResearchID,
    a.Running;


-- Proportion correct by SupportType
create or replace algorithm = undefined view backend.q_Blending_SupportPropCorrect as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `Blending_TrialType`,
    a.SupportType as `Blending_SupportType`,
    sum(a.Administered) as `Blending_NumTrialsAdministered`,
    round(avg(a.Correct), 4.0) as `Blending_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.Blending_Admin b
      using (ChildStudyID)
    left join backend.Blending_Responses a
      using (BlendingID)
  where
    b.Blending_Completion is not null
  group by
    b.BlendingID,
    a.Running,
    a.SupportType
  order by
    c.Study,
    d.ShortResearchID,
    a.Running,
    a.SupportType;


-- Proportion correct by Support x BlendType
create or replace algorithm = undefined view backend.q_Blending_ModulePropCorrect as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `Blending_TrialType`,
    a.SupportType as `Blending_SupportType`,
    a.BlendType as `Blending_BlendType`,
    sum(a.Administered) as `Blending_NumTrialsAdministered`,
    round(avg(a.Correct), 4.0) as `Blending_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.Blending_Admin b
      using (ChildStudyID)
    left join backend.Blending_Responses a
      using (BlendingID)
  where
    b.Blending_Completion is not null
  group by
    b.BlendingID,
    a.Running,
    a.SupportType,
    a.BlendType
  order by
    c.Study,
    d.ShortResearchID,
    a.Running,
    a.SupportType,
    a.BlendType;


-- Combine information from other views into a wide table
create or replace algorithm = undefined view backend.q_Blending_Summary as
  select
    overall_prop.ChildStudyID,
    overall_prop.Study,
    overall_prop.ResearchID,
    overall_prop.BlendingID,
    overall_prop.Blending_EprimeFile,
    overall_prop.Blending_Completion,
    overall_prop.Blending_Age,
    overall_prop.Blending_NumTrialsAdministered as `Blending_BothConditions_NumTrials`,
    overall_prop.Blending_ProportionCorrect as `Blending_BothConditions_ProportionCorrect`,
    -- https://stackoverflow.com/questions/2255640/mysql-reshape-data-from-long-tall-to-wide - the `group by` is crucial
    max(case when support_prop.Blending_SupportType = 'Audiovisual' then support_prop.Blending_NumTrialsAdministered else null end) as `Blending_Audiovisual_NumTrials`,
    max(case when support_prop.Blending_SupportType = 'Audiovisual' then support_prop.Blending_ProportionCorrect else null end) as `Blending_Audiovisual_ProportionCorrect`,
    max(case when support_prop.Blending_SupportType = 'Audio' then support_prop.Blending_NumTrialsAdministered else null end) as `Blending_Audio_NumTrials`,
    max(case when support_prop.Blending_SupportType = 'Audio' then support_prop.Blending_ProportionCorrect else null end) as `Blending_Audio_ProportionCorrect`
  from
    backend.q_Blending_PropCorrect overall_prop
    left join backend.q_Blending_SupportPropCorrect support_prop
      using (BlendingID)
  where
    overall_prop.Blending_TrialType = "Test" and
    support_prop.Blending_TrialType = "Test"
  group by
    overall_prop.BlendingID
  order by
    overall_prop.Study,
    overall_prop.ResearchID;


-- User-facing version
create or replace algorithm = undefined view l2t.Blending_Summary as
  select
    Study,
    ResearchID,
    Blending_EprimeFile,
    Blending_Completion,
    Blending_Age,
    Blending_BothConditions_NumTrials,
    Blending_BothConditions_ProportionCorrect,
    Blending_Audiovisual_NumTrials,
    Blending_Audiovisual_ProportionCorrect,
    Blending_Audio_NumTrials,
    Blending_Audio_ProportionCorrect
  from
    backend.q_Blending_Summary
  order by
    Study,
    ResearchID;
