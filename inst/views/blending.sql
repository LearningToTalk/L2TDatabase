--
-- Create views to summarize the Blending experiment
--


-- Overall proportion correct
alter algorithm = undefined view `q_Blending_PropCorrect` as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `TrialType`,
    sum(a.Administered) as `NumTrialsAdministered`,
    round(avg(a.Correct), 4.0 ) as  `ProportionCorrect`
  from
    ChildStudy d
    left join Study c
      using ( StudyID )
    left join Blending_Admin b
      using ( ChildStudyID )
    left join Blending_Responses a
      using ( BlendingID )
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
alter algorithm = undefined view `q_Blending_SupportPropCorrect` as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `TrialType`,
    a.SupportType as `SupportType`,
    sum(a.Administered) as `NumTrialsAdministered`,
    round(avg(a.Correct), 4.0 ) as  `ProportionCorrect`
  from
    ChildStudy d
    left join Study c
      using ( StudyID )
    left join Blending_Admin b
      using ( ChildStudyID )
    left join Blending_Responses a
      using ( BlendingID )
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
alter algorithm = undefined view `q_Blending_ModulesPropCorrect` as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.BlendingID,
    b.Blending_EprimeFile,
    b.Blending_Completion,
    b.Blending_Age,
    a.Running as `TrialType`,
    a.SupportType as `SupportType`,
    a.BlendType as `BlendType`,
    sum(a.Administered) as `NumTrialsAdministered`,
    round(avg(a.Correct), 4.0 ) as  `ProportionCorrect`
  from
    ChildStudy d
    left join Study c
      using ( StudyID )
    left join Blending_Admin b
      using ( ChildStudyID )
    left join Blending_Responses a
      using ( BlendingID )
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
alter algorithm = undefined view `q_Blending_Summary` as
  select
    overall_prop.ChildStudyID,
    overall_prop.Study,
    overall_prop.ResearchID,
    overall_prop.BlendingID,
    overall_prop.Blending_EprimeFile,
    overall_prop.Blending_Completion,
    overall_prop.Blending_Age,
    overall_prop.NumTrialsAdministered as `Blending_NumTrials_BothConditions`,
    overall_prop.ProportionCorrect as `Blending_ProportionCorrect_BothConditions`,
    -- https://stackoverflow.com/questions/2255640/mysql-reshape-data-from-long-tall-to-wide - the `group by` is crucial
    max(case when support_prop.SupportType = 'Audiovisual' then support_prop.NumTrialsAdministered else null end) as `Blending_NumTrials_Audiovisual`,
    max(case when support_prop.SupportType = 'Audiovisual' then support_prop.ProportionCorrect else null end) as `Blending_ProportionCorrect_Audiovisual`,
    max(case when support_prop.SupportType = 'Audio' then support_prop.NumTrialsAdministered else null end) as `Blending_NumTrials_Audio`,
    max(case when support_prop.SupportType = 'Audio' then support_prop.ProportionCorrect else null end) as `Blending_ProportionCorrect_Audio`
  from
    q_Blending_PropCorrect overall_prop
    left join q_Blending_SupportPropCorrect support_prop
      using (BlendingID)
  where
    overall_prop.TrialType = "Test" and support_prop.TrialType = "Test"
  group by
    overall_prop.BlendingID
  order by
    overall_prop.Study,
    overall_prop.ResearchID;
