--
-- Create a view to display the test scores of TimePoint3 participants
--

CREATE ALGORITHM = UNDEFINED VIEW  `q_Scores_TimePoint3` AS SELECT a.Study, b.ShortResearchID AS  `ResearchID` , c.Female, c.AAE, c.LateTalker, c.CImplant, c.Birthdate, d.EVT_Completion, d.EVT_Form, d.EVT_Raw, d.EVT_GSV, d.EVT_Age, d.EVT_Standard, e.PPVT_Completion, e.PPVT_Form, e.PPVT_Raw, e.PPVT_GSV, e.PPVT_Age, e.PPVT_Standard
FROM Study a
LEFT JOIN ChildStudy b
USING ( StudyID )
LEFT JOIN Child c
USING ( ChildID )
LEFT JOIN EVT d
USING ( ChildStudyID )
LEFT JOIN PPVT e
USING ( ChildStudyID )
WHERE a.Study =  "TimePoint3"
ORDER BY b.ShortResearchID
