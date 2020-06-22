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








-- Create views to summarize the Minimal Pairs experiment

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




-- Combine information from other views into a wide table
create or replace algorithm = undefined view backend.q_MinPair_Dialect_Summary as
  select
    minp_agg.ChildStudyID,
    minp_agg.Study,
    minp_agg.ResearchID,
    (case when child.AAE = 1 then 'AAE' when child.AAE = 0 then 'SAE' else null end) as Child_Dialect,
    max(case when minp_agg.MinPair_Dialect = 'AAE' then minp_agg.MinPair_Completion else null end) as MinPair_AAE_Completion,
    max(case when minp_agg.MinPair_Dialect = 'SAE' then minp_agg.MinPair_Completion else null end) as MinPair_SAE_Completion,
    max(case when minp_agg.MinPair_Dialect = 'AAE' then minp_agg.MinPair_Age else null end) as MinPair_AAE_Age,
    max(case when minp_agg.MinPair_Dialect = 'SAE' then minp_agg.MinPair_Age else null end) as MinPair_SAE_Age,
    max(case when minp_agg.MinPair_Dialect = 'AAE' then minp_agg.MinPair_NumTestTrials else null end) as MinPair_AAE_NumTestTrials,
    max(case when minp_agg.MinPair_Dialect = 'SAE' then minp_agg.MinPair_NumTestTrials else null end) as MinPair_SAE_NumTestTrials,
    max(case when minp_agg.MinPair_Dialect = 'AAE' then minp_agg.MinPair_ProportionCorrect else null end) as MinPair_AAE_ProportionCorrect,
    max(case when minp_agg.MinPair_Dialect = 'SAE' then minp_agg.MinPair_ProportionCorrect else null end) as MinPair_SAE_ProportionCorrect
  from
    backend.q_MinPair_Aggregate minp_agg
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Child child
      using (ChildID)
  where
    Study in ("DialectSwitch", "MaternalEd")
  group by
    minp_agg.ChildStudyID
  order by
    minp_agg.Study,
    minp_agg.ResearchID;


create or replace algorithm = undefined view l2t.MinPair_Dialect_Summary as
  select
    minp_dialect.Study,
    minp_dialect.ResearchID,
    minp_dialect.Child_Dialect,
    minp_dialect.MinPair_AAE_Completion,
    minp_dialect.MinPair_SAE_Completion,
    minp_dialect.MinPair_AAE_Age,
    minp_dialect.MinPair_SAE_Age,
    minp_dialect.MinPair_AAE_NumTestTrials,
    minp_dialect.MinPair_SAE_NumTestTrials,
    minp_dialect.MinPair_AAE_ProportionCorrect,
    minp_dialect.MinPair_SAE_ProportionCorrect
  from
    backend.q_MinPair_Dialect_Summary minp_dialect
  order by
    minp_dialect.Study,
    minp_dialect.ResearchID;


-- Create views to summarize the SAILS experiment

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
    -- there will be only one value here so the min() is the unique value
    min(p.SAILS_ProportionCorrect) as `SAILS_ProportionTestCorrect`
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


-- User-facing version
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
create or replace algorithm = undefined view cla_l2t.SAILS_Responses as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.SAILSID,
    b.SAILS_EprimeFile,
    b.SAILS_Completion,
    b.SAILS_Dialect,
    b.SAILS_Age,
    a.Running as SAILS_Running,
    a.Module as SAIL_Module,
    a.Cycle as SAILS_Cycle,
    a.Trial as SAILS_Trial,
    a.Sound as SAILS_Sound,
    a.CorrectResponse as SAILS_TargetResponse,
    a.Response as SAILS_Response,
    a.Correct as SAILS_Correct
  from
    cla_l2t_backend.ChildStudy d
    left join cla_l2t_backend.Study c
      using (StudyID)
    left join cla_l2t_backend.SAILS_Admin b
      using (ChildStudyID)
    left join cla_l2t_backend.SAILS_Responses a
      using (SAILSID)
  order by
    c.Study,
    d.ShortResearchID;


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








-- Create views to summarize the Rhyming experiment

-- Create a view to display the proportion correct for non-training trials in
-- each administration of the Rhyming experiment.
create or replace algorithm = undefined view backend.q_Rhyming_PropCorrect as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as ResearchID,
    b.RhymingID,
    b.Rhyming_EprimeFile,
    b.Rhyming_Completion,
    b.Rhyming_Age,
    round(avg(a.Correct), 4.0) as Rhyming_ProportionCorrect
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.Rhyming_Admin b
      using (ChildStudyID)
    left join backend.Rhyming_Responses a
      using (RhymingID)
  where
    a.Running = "Test"
  group by
    b.RhymingID
  order by
    c.Study,
    d.ShortResearchID;


-- Create a view to display the proportion correct for non-training trials in
-- each administration of the Rhyming experiment, along with counts of training
-- and non-training trials.
create or replace algorithm = undefined view backend.q_Rhyming_Aggregate as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as ResearchID,
    b.Rhyming_EprimeFile,
    b.Rhyming_Completion,
    b.Rhyming_Age,
    count(case a.Running when "Familiarization" then 1 else null end) as Rhyming_NumPracticeTrials,
    count(case a.Running when "Test" then 1 else null end) as Rhyming_NumTestTrials,
    p.Rhyming_ProportionCorrect as Rhyming_ProportionTestCorrect
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.Rhyming_Admin b
      using (ChildStudyID)
    left join backend.Rhyming_Responses a
      using (RhymingID)
    left join backend.q_Rhyming_PropCorrect p
      using (RhymingID)
  where
    b.Rhyming_Completion is not null
  group by
    b.RhymingID
  order by
    c.Study,
    d.ShortResearchID;


-- User-facing version
create or replace algorithm = undefined view l2t.Rhyming_Aggregate as
  select
    Study,
    ResearchID,
    Rhyming_EprimeFile,
    Rhyming_Completion,
    Rhyming_Age,
    Rhyming_NumPracticeTrials,
    Rhyming_NumTestTrials,
    Rhyming_ProportionTestCorrect
  from
    backend.q_Rhyming_Aggregate
  order by
    Study,
    ResearchID;

