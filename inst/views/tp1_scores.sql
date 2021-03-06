-- Create a view to display the test scores of TimePoint1 participants
create or replace algorithm = undefined view  l2t.Scores_TimePoint1 as
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
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_NumTestTrials,
    minpair.MinPair_ProportionCorrect,
    rwr.RealWordRep_Completion,
    rwr.RealWordRep_Age,
    rwr.RealWordRep_Experiment,
    lena.LENA_Completion,
    lena.LENA_Age,
    lena.LENA_FirstHour,
    lena.LENA_FinalHour,
    lena.LENA_Hours,
    lena.LENA_Prop_Meaningful,
    lena.LENA_Prop_Distant,
    lena.LENA_Prop_TV,
    lena.LENA_Prop_Noise,
    lena.LENA_Prop_Silence,
    lena.LENA_AWC_Hourly,
    lena.LENA_CTC_Hourly,
    lena.LENA_CVC_Hourly
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
    left join backend.FruitStroop fruit
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.RealWordRep_Admin rwr
      using (ChildStudyID)
    left join backend.q_LENA_Averages lena
      using (ChildStudyID)
    left join backend.q_Task_Ages_Summary ages
      using (ChildStudyID)
  where
    study.Study = "TimePoint1"
  order by
    childstudy.ShortResearchID;
