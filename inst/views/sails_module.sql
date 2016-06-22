--
-- Create a view to display the proportion correct for non-training trials in
-- each module of each administration of the SAILS experiment.
--

CREATE ALGORITHM = UNDEFINED VIEW `q_SAILS_ModulesPropCorrect` AS
  SELECT d.ChildStudyID, c.Study, d.ShortResearchID AS `ResearchID`, b.SAILS_EprimeFile,
    b.SAILSID, b.SAILS_Completion, b.SAILS_Dialect, b.SAILS_Age, a.Module,
    ROUND( AVG( a.Correct ) , 4.0 ) AS  `ProportionCorrect`
  FROM ChildStudy d
  LEFT JOIN Study c
  USING ( StudyID )
  LEFT JOIN SAILS_Admin b
  USING ( ChildStudyID )
  LEFT JOIN SAILS_Responses a
  USING ( SAILSID )
  WHERE a.Running =  "Test"
  GROUP BY b.SAILSID, a.Module
  ORDER BY c.Study, d.ShortResearchID, a.Module
