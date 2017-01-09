create algorithm = undefined view  `q_Scores_CochlearV1` as
  select
    childstudy.ChildStudyID,
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
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
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect
  from
    Study study
    left join ChildStudy childstudy
      using (StudyID)
    left join Child child
      using (ChildID)
    left join q_Household_Max_Maternal_Education medu
      using (HouseholdID)
    left join EVT evt
      using (ChildStudyID)
    left join PPVT ppvt
      using (ChildStudyID)
    left join GFTA gfta
      using (ChildStudyID)
    left join VerbalFluency vf
      using (ChildStudyID)
    left join FruitStroop fruit
      using (ChildStudyID)
    left join q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join q_SAILS_Aggregate sails
      using (ChildStudyID)
  where
    study.Study = "CochlearV1"
  order by
    childstudy.ShortResearchID;

create algorithm = undefined view  `q_Scores_CochlearV2` as
  select
    childstudy.ChildStudyID,
    study.Study,
    childstudy.ShortResearchID as `ResearchID`,
    child.Female,
    child.AAE,
    child.LateTalker,
    child.CImplant,
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
    minpair.MinPair_Completion,
    minpair.MinPair_Age,
    minpair.MinPair_ProportionCorrect,
    sails.SAILS_Completion,
    sails.SAILS_Age,
    sails.SAILS_NumPracticeTrials,
    sails.SAILS_NumTestTrials,
    sails.SAILS_ProportionTestCorrect
  from
    Study study
    left join ChildStudy childstudy
      using (StudyID)
    left join Child child
      using (ChildID)
    left join q_Household_Max_Maternal_Education medu
      using (HouseholdID)
    left join EVT evt
      using (ChildStudyID)
    left join PPVT ppvt
      using (ChildStudyID)
    left join GFTA gfta
      using (ChildStudyID)
    left join VerbalFluency vf
      using (ChildStudyID)
    left join FruitStroop fruit
      using (ChildStudyID)
    left join q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join q_SAILS_Aggregate sails
      using (ChildStudyID)
  where
    study.Study = "CochlearV2"
  order by
    childstudy.ShortResearchID;