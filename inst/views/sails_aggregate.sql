--
-- Create a view to display the proportion correct for non-training trials in
-- each administration of the SAILS experiment, along with counts of training
-- and non-training trials.
--

CREATE ALGORITHM = UNDEFINED VIEW  `q_SAILS_Aggregate` AS
  SELECT d.ChildStudyID, c.Study, d.ShortResearchID AS `ResearchID`,
    b.SAILSID, b.SAILS_EprimeFile, b.SAILS_Completion, b.SAILS_Age, b.SAILS_Dialect,
    COUNT( case a.Running when "Familiarization" then 1 else null end) AS `SAILS_NumPracticeTrials`,
    COUNT( case a.Running when "Test" then 1 else null end) AS `SAILS_NumTestTrials`,
    p.SAILS_ProportionCorrect AS `SAILS_ProportionTestCorrect`
  FROM ChildStudy d
  LEFT JOIN Study c
  USING ( StudyID )
  LEFT JOIN SAILS_Admin b
  USING ( ChildStudyID )
  LEFT JOIN SAILS_Responses a
  USING ( SAILSID )
  LEFT JOIN q_SAILS_PropCorrect p
  USING ( SAILSID )
  WHERE b.SAILS_Completion IS NOT NULL
  GROUP BY b.SAILSID
  ORDER BY c.Study, d.ShortResearchID
