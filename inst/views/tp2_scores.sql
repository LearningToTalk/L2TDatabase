-- Create a view to display the test scores of TimePoint2 participants
create or replace algorithm = undefined view  l2t.Scores_TimePoint2 as
  select
    childstudy.ChildStudyID,
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
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq,
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    ctopp_blending.CTOPP_Blending_Completion,
    ctopp_blending.CTOPP_Blending_Age,
    ctopp_blending.CTOPP_Blending_Raw,
    ctopp_blending.CTOPP_Blending_Scaled,
    ctopp_elision.CTOPP_Elision_Completion,
    ctopp_elision.CTOPP_Elision_Age,
    ctopp_elision.CTOPP_Elision_Raw,
    ctopp_elision.CTOPP_Elision_Scaled,
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
    rwr.RealWordRep_Experiment,
    blending.Blending_Completion,
    blending.Blending_Age,
    blending.Blending_BothConditions_NumTrials,
    blending.Blending_BothConditions_ProportionCorrect,
    blending.Blending_Audiovisual_NumTrials,
    blending.Blending_Audiovisual_ProportionCorrect,
    blending.Blending_Audio_NumTrials,
    blending.Blending_Audio_ProportionCorrect,
    rhyming.Rhyming_Completion,
    rhyming.Rhyming_Age,
    rhyming.Rhyming_NumPracticeTrials,
    rhyming.Rhyming_NumTestTrials,
    rhyming.Rhyming_ProportionTestCorrect,
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
    left join backend.FruitStroop fruit
      using (ChildStudyID)
    left join backend.q_MinPair_Aggregate minpair
      using (ChildStudyID)
    left join backend.q_SAILS_Aggregate sails
      using (ChildStudyID)
    left join backend.RealWordRep_Admin rwr
      using (ChildStudyID)
    left join backend.q_Blending_Summary blending
      using (ChildStudyID)
    left join backend.q_Rhyming_Aggregate rhyming
      using (ChildStudyID)
    left join backend.q_LENA_Averages lena
      using (ChildStudyID)
    left join backend.CTOPP_Blending ctopp_blending
      using (ChildStudyID)
    left join backend.CTOPP_Elision ctopp_elision
      using (ChildStudyID)
    left join backend.KBIT kbit
      using (ChildStudyID)
  where
    study.Study = "TimePoint2"
  order by
    childstudy.ShortResearchID;
