-- Create user-facing views for various tests.

-- EVT
create or replace algorithm = undefined view  l2t.EVT as
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
