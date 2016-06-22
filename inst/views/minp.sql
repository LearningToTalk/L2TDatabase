--
-- Create a view to display the proportion correct for non-training trials in
-- each administration of the Minimal Pairs experiment.
--

CREATE ALGORITHM = UNDEFINED VIEW  `q_MinPair_Aggregate` AS
  SELECT d.ChildStudyID, c.Study, d.ShortResearchID AS `ResearchID`,
    b.MinPairID, b.MinPair_EprimeFile, b.MinPair_Completion, b.MinPair_Dialect,
    ROUND( AVG( a.Correct ) , 4.0 ) AS `MinPair_ProportionCorrect`
  FROM ChildStudy d
  LEFT JOIN Study c
  USING ( StudyID )
  LEFT JOIN MinPair_Admin b
  USING ( ChildStudyID )
  LEFT JOIN MinPair_Responses a
  USING ( MinPairID )
  WHERE a.Running = "Test"
  GROUP BY b.MinPairID
  ORDER BY b.MinPairID
