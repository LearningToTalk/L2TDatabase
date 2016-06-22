--
-- Create a view to display the test scores of TimePoint3 participants
-- Replace CREATE with ALTER to update an existing view
--

CREATE ALGORITHM = UNDEFINED VIEW  `q_Scores_TimePoint3` AS
  SELECT b.ChildStudyID, a.Study, b.ShortResearchID AS  `ResearchID`,
    c.Female, c.AAE, c.LateTalker, c.CImplant,
    d.EVT_Completion, d.EVT_Form, d.EVT_Raw, d.EVT_GSV, d.EVT_Age, d.EVT_Standard,
    e.PPVT_Completion, e.PPVT_Form, e.PPVT_Raw, e.PPVT_GSV, e.PPVT_Age, e.PPVT_Standard,
    f.VerbalFluency_Completion, f.VerbalFluency_Age, f.VerbalFluency_Raw, f.VerbalFluency_AgeEq,
    i.MinPair_ProportionCorrect,
    j.SAILS_Age, j.SAILS_NumPracticeTrials, j.SAILS_NumTestTrials, j.SAILS_ProportionTestCorrect
  FROM Study a
  LEFT JOIN ChildStudy b
  USING ( StudyID )
  LEFT JOIN Child c
  USING ( ChildID )
  LEFT JOIN EVT d
  USING ( ChildStudyID )
  LEFT JOIN PPVT e
  USING ( ChildStudyID )
  LEFT JOIN VerbalFluency f
  USING ( ChildStudyID )
  LEFT JOIN q_MinPair_Aggregate i
  USING ( ChildStudyID )
  LEFT JOIN q_SAILS_Aggregate j
  USING ( ChildStudyID )
  WHERE a.Study = "TimePoint3"
  ORDER BY b.ShortResearchID
