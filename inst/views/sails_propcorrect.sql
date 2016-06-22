--
-- Create a view to display the proportion correct for non-training trials in
-- each administration of the SAILS experiment.
--

CREATE ALGORITHM = UNDEFINED VIEW  `q_SAILS_PropCorrect` AS
  SELECT d.ChildStudyID, c.Study, d.ShortResearchID AS `ResearchID`,
    b.SAILSID, b.SAILS_EprimeFile, b.SAILS_Completion, b.SAILS_Dialect, b.SAILS_Age,
    ROUND( AVG( a.Correct ) , 4.0 ) AS  `SAILS_ProportionCorrect`
  FROM ChildStudy d
  LEFT JOIN Study c
  USING ( StudyID )
  LEFT JOIN SAILS_Admin b
  USING ( ChildStudyID )
  LEFT JOIN SAILS_Responses a
  USING ( SAILSID )
  WHERE a.Running = "Test"
  GROUP BY b.SAILSID
  ORDER BY c.Study, d.ShortResearchID
