create or replace algorithm = undefined view l2t.Scores_CochlearV1 as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
    child.HouseholdID,
    medu.Caregiver_Relation as `Maternal_Caregiver`,
    medu.Caregiver_EduCategory as `Maternal_Education`,
    medu.Caregiver_EduScale as `Maternal_Education_Level`,
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
    gfta.GFTA_Completion,
    gfta.GFTA_Age,
    gfta.GFTA_RawCorrect,
    gfta.GFTA_NumTranscribed,
    gfta.GFTA_AdjCorrect,
    gfta.GFTA_Standard,
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq,
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    ctopp_memory.CTOPP_Memory_Completion,
    ctopp_memory.CTOPP_Memory_Age,
    ctopp_memory.CTOPP_Memory_Raw,
    ctopp_memory.CTOPP_Memory_Scaled,
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_NumTestTrials,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect,
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
    left join backend.GFTA gfta
      using (ChildStudyID)
    left join backend.VerbalFluency vf
      using (ChildStudyID)
    left join backend.FruitStroop fruit
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.q_SAILS_Aggregate sails
      using (ChildStudyID)
    left join backend.q_LENA_Averages lena
      using (ChildStudyID)
    left join backend.CTOPP_Memory ctopp_memory
      using (ChildStudyID)
  where
    study.Study = "CochlearV1"
  order by
    childstudy.ShortResearchID;

create or replace algorithm = undefined view l2t.Scores_CochlearV2 as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
    child.HouseholdID,
    medu.Caregiver_Relation as `Maternal_Caregiver`,
    medu.Caregiver_EduCategory as `Maternal_Education`,
    medu.Caregiver_EduScale as `Maternal_Education_Level`,
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
    gfta.GFTA_Completion,
    gfta.GFTA_Age,
    gfta.GFTA_RawCorrect,
    gfta.GFTA_NumTranscribed,
    gfta.GFTA_AdjCorrect,
    gfta.GFTA_Standard,
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq,
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    ctopp_memory.CTOPP_Memory_Completion,
    ctopp_memory.CTOPP_Memory_Age,
    ctopp_memory.CTOPP_Memory_Raw,
    ctopp_memory.CTOPP_Memory_Scaled,
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_NumTestTrials,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect,
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
    left join backend.GFTA gfta
      using (ChildStudyID)
    left join backend.VerbalFluency vf
      using (ChildStudyID)
    left join backend.FruitStroop fruit
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.q_SAILS_Aggregate sails
      using (ChildStudyID)
    left join backend.q_LENA_Averages lena
      using (ChildStudyID)
    left join backend.CTOPP_Memory ctopp_memory
      using (ChildStudyID)
  where
    study.Study = "CochlearV2"
  order by
    childstudy.ShortResearchID;


create or replace algorithm = undefined view l2t.Scores_CochlearMatching as
  select
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
    child.HouseholdID,
    medu.Caregiver_Relation as `Maternal_Caregiver`,
    medu.Caregiver_EduCategory as `Maternal_Education`,
    medu.Caregiver_EduScale as `Maternal_Education_Level`,
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
    gfta.GFTA_Completion,
    gfta.GFTA_Age,
    gfta.GFTA_RawCorrect,
    gfta.GFTA_NumTranscribed,
    gfta.GFTA_AdjCorrect,
    gfta.GFTA_Standard,
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq,
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    ctopp_memory.CTOPP_Memory_Completion,
    ctopp_memory.CTOPP_Memory_Age,
    ctopp_memory.CTOPP_Memory_Raw,
    ctopp_memory.CTOPP_Memory_Scaled,
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_NumTestTrials,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect,
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
    left join backend.GFTA gfta
      using (ChildStudyID)
    left join backend.VerbalFluency vf
      using (ChildStudyID)
    left join backend.FruitStroop fruit
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.q_SAILS_Aggregate sails
      using (ChildStudyID)
    left join backend.q_LENA_Averages lena
      using (ChildStudyID)
    left join backend.CTOPP_Memory ctopp_memory
      using (ChildStudyID)
  where
    study.Study = "CochlearMatching"
  order by
    childstudy.ShortResearchID;
