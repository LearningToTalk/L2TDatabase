-- Create user-facing views for various tests.

-- EVT
create or replace algorithm = undefined view l2t.EVT as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    evt.EVT_Completion,
    evt.EVT_Form,
    evt.EVT_Age,
    evt.EVT_Raw,
    evt.EVT_GSV,
    evt.EVT_Standard,
    evt.EVT_Note
  from
    backend.EVT evt
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- PPVT
create or replace algorithm = undefined view l2t.PPVT as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    ppvt.PPVT_Completion,
    ppvt.PPVT_Form,
    ppvt.PPVT_Age,
    ppvt.PPVT_Raw,
    ppvt.PPVT_GSV,
    ppvt.PPVT_Standard,
    ppvt.PPVT_Note
  from
    backend.PPVT ppvt
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- GFTA
create or replace algorithm = undefined view l2t.GFTA as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    gfta.GFTA_Completion,
    gfta.GFTA_Age,
    gfta.GFTA_RawCorrect,
    gfta.GFTA_NumTranscribed,
    gfta.GFTA_AdjCorrect,
    gfta.GFTA_Standard
  from
    backend.GFTA gfta
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- FruitStroop
create or replace algorithm = undefined view l2t.FruitStroop as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    fruit.FruitStroop_Completion,
    fruit.FruitStroop_Age,
    fruit.FruitStroop_Score,
    fruit.FruitStroop_Raw as FruitStroop_TotalPoints
  from
    backend.FruitStroop fruit
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- VerbalFluency
create or replace algorithm = undefined view l2t.VerbalFluency as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    vf.VerbalFluency_Completion,
    vf.VerbalFluency_Age,
    vf.VerbalFluency_Raw,
    vf.VerbalFluency_AgeEq
  from
    backend.VerbalFluency vf
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- CTOPP_Blending
create or replace algorithm = undefined view l2t.CTOPP_Blending as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    ctopp.CTOPP_Blending_Completion,
    ctopp.CTOPP_Blending_Age,
    ctopp.CTOPP_Blending_Raw,
    ctopp.CTOPP_Blending_Scaled,
    ctopp.CTOPP_Blending_Notes
  from
    backend.CTOPP_Blending ctopp
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- CTOPP_Elision
create or replace algorithm = undefined view l2t.CTOPP_Elision as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    ctopp.CTOPP_Elision_Completion,
    ctopp.CTOPP_Elision_Age,
    ctopp.CTOPP_Elision_Raw,
    ctopp.CTOPP_Elision_Scaled,
    ctopp.CTOPP_Elision_Notes
  from
    backend.CTOPP_Elision ctopp
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;


-- CTOPP_Memory
create or replace algorithm = undefined view l2t.CTOPP_Memory as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    ctopp.CTOPP_Memory_Completion,
    ctopp.CTOPP_Memory_Age,
    ctopp.CTOPP_Memory_Raw,
    ctopp.CTOPP_Memory_Scaled,
    ctopp.CTOPP_Memory_Notes
  from
    backend.CTOPP_Memory ctopp
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;




-- BRIEF
create or replace algorithm = undefined view l2t.BRIEF as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    brief.BRIEF_Completion,
    brief.BRIEF_Age,
    brief.Inhibit_Raw,
    brief.Inhibit_TScore,
    brief.Inhibit_Percentile,
    brief.Shift_Raw,
    brief.Shift_TScore,
    brief.Shift_Percentile,
    brief.EC_Raw,
    brief.EC_TScore,
    brief.EC_Percentile,
    brief.WM_Raw,
    brief.WM_TScore,
    brief.WM_Percentile,
    brief.PO_Raw,
    brief.PO_TScore,
    brief.PO_Percentile,
    brief.ISCI_Raw,
    brief.ISCI_TScore,
    brief.ISCI_Percentile,
    brief.FI_Raw,
    brief.FI_TScore,
    brief.FI_Percentile,
    brief.EMI_Raw,
    brief.EMI_TScore,
    brief.EMI_Percentile,
    brief.GEC_Raw,
    brief.GEC_TScore,
    brief.GEC_Percentile,
    brief.BRIEF_Note
  from
    backend.BRIEF brief
    left join backend.ChildStudy childstudy
      using (ChildStudyID)
    left join backend.Study study
      using (StudyID)
  order by
    study.Study,
    childstudy.ShortResearchID;
