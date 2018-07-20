--
-- Create a view to display the test scores of TimePoint3 participants
-- Replace "create" with "alter" to update an existing view
--

create or replace algorithm = undefined view l2t.Scores_TimePoint3 as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
    child.ChildID,
    childstudy.ChildStudyID,
    child.HouseholdID,
    medu.Caregiver_Relation as `Maternal_Caregiver`,
    medu.Caregiver_EduCategory as `Maternal_Education`,
    medu.Caregiver_EduScale as `Maternal_Education_Level`,
    ages.Task_Age_Min,
    ages.Task_Age_Max,
    ages.Task_Age_Range,
    evt.EVT_Completion,
    evt.EVT_Form,
    evt.EVT_Raw,
    evt.EVT_GSV,
    evt.EVT_Age,
    evt.EVT_Standard,
    ppvt.PPVT_Completion,
    ppvt.PPVT_Form,
    ppvt.PPVT_Raw,
    ppvt.PPVT_GSV,
    ppvt.PPVT_Age,
    ppvt.PPVT_Standard,
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq,
    gfta.GFTA_Completion,
    gfta.GFTA_Age,
    gfta.GFTA_RawCorrect,
    gfta.GFTA_NumTranscribed,
    gfta.GFTA_AdjCorrect,
    gfta.GFTA_Standard,
    ctopp_blending.CTOPP_Blending_Completion,
    ctopp_blending.CTOPP_Blending_Age,
    ctopp_blending.CTOPP_Blending_Raw,
    ctopp_blending.CTOPP_Blending_Scaled,
    ctopp_elision.CTOPP_Elision_Completion,
    ctopp_elision.CTOPP_Elision_Age,
    ctopp_elision.CTOPP_Elision_Raw,
    ctopp_elision.CTOPP_Elision_Scaled,
    ctopp_memory.CTOPP_Memory_Completion,
    ctopp_memory.CTOPP_Memory_Age,
    ctopp_memory.CTOPP_Memory_Raw,
    ctopp_memory.CTOPP_Memory_Scaled,
    kbit.KBIT_Completion,
    kbit.KBIT_Age,
    kbit.KBIT_Nonverbal_Raw,
    kbit.KBIT_Nonverbal_Standard,
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_NumTestTrials,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect,
    rwr.RealWordRep_Completion,
    rwr.RealWordRep_Age,
    rwr.RealWordRep_Experiment
  from
    backend.Study study
    left join backend.ChildStudy childstudy
      using (StudyID)
    left join backend.Child child
      using (ChildID)
    left join backend.q_Household_Max_Maternal_Education medu
      using (HouseholdID)
    left join backend.EVT evt
      using (ChildStudyID)
    left join backend.PPVT ppvt
      using (ChildStudyID)
    left join backend.VerbalFluency vf
      using (ChildStudyID)
    left join backend.GFTA gfta
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.q_SAILS_Aggregate sails
      using (ChildStudyID)
    left join backend.RealWordRep_Admin rwr
      using (ChildStudyID)
    left join backend.CTOPP_Blending ctopp_blending
      using (ChildStudyID)
    left join backend.CTOPP_Elision ctopp_elision
      using (ChildStudyID)
    left join backend.CTOPP_Memory ctopp_memory
      using (ChildStudyID)
    left join backend.KBIT kbit
      using (ChildStudyID)
    left join backend.q_Task_Ages_Summary ages
      using (ChildStudyID)
  where
    study.Study = "TimePoint3"
  order by
    childstudy.ShortResearchID;


-- MPNorming Results
create or replace algorithm = undefined view l2t.MPNormingClosed_Items as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.MPNormingClosed_Admin_Completion as `MPNormingClosed_Completion`,
    b.MPNormingClosed_Admin_Age as `MPNormingClosed_Age`,
    e.ItemSet as `MPNormingClosed_ItemSet`,
    e.ItemNumber as `MPNormingClosed_ItemNumber`,
    e.Item as `MPNormingClosed_Item`,
    e.Type as `MPNormingClosed_Type`,
    f.MPNormingClosed_Responses_Correct as `MPNormingClosed_Correct`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.MPNormingClosed_Admin b
      using (ChildStudyID)
    left join backend.MPNormingClosed_Responses f
      using (MPNormingClosed_AdminID)
    left join backend.MPNormingClosed_Design e
      using (MPNormingClosed_DesignID)
  where
    b.MPNormingClosed_Admin_Completion is not null
  order by
    c.Study,
    d.ShortResearchID,
    e.ItemNumber;

-- MPNorming Results
create or replace algorithm = undefined view l2t.MPNormingClosed_Averages as
  select
    d.ChildStudyID,
    c.Study,
    d.ShortResearchID as `ResearchID`,
    b.MPNormingClosed_Admin_Completion as `MPNormingClosed_Completion`,
    b.MPNormingClosed_Admin_Age as `MPNormingClosed_Age`,
    e.ItemSet as `MPNormingClosed_ItemSet`,
    e.Item as `MPNormingClosed_Item`,
    e.Type as `MPNormingClosed_Type`,
    count(f.MPNormingClosed_Responses_Correct) as `MPNormingClosed_NumTrials`,
    sum(f.MPNormingClosed_Responses_Correct) as `MPNormingClosed_NumCorrectTrials`,
    round(avg(f.MPNormingClosed_Responses_Correct), 4.0) as `MPNormingClosed_ProportionCorrect`
  from
    backend.ChildStudy d
    left join backend.Study c
      using (StudyID)
    left join backend.MPNormingClosed_Admin b
      using (ChildStudyID)
    left join backend.MPNormingClosed_Responses f
      using (MPNormingClosed_AdminID)
    left join backend.MPNormingClosed_Design e
      using (MPNormingClosed_DesignID)
  where
    b.MPNormingClosed_Admin_Completion is not null
  group by
    c.Study,
    d.ShortResearchID,
    b.MPNormingClosed_Admin_Completion,
    e.Type
  order by
    c.Study,
    d.ShortResearchID;
