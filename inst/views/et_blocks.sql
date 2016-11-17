-- Create queries for the eyetracking database.
-- Switch ALTER to CREATE to create the views anew. Otherwise, use ALTER to
-- update the views.

ALTER ALGORITHM = UNDEFINED VIEW `q_BlocksByStudy` AS
SELECT `d`.`Study` AS `Study`,
       `c`.`ShortResearchID` AS `ResearchID`,
       `a`.`Block_Task` AS `Task`,
       `a`.`Block_Version` AS `Version`,
       `a`.`Block_Basename` AS `Basename`,
       `a`.`Block_DateTime` AS `DateTime`,
       `a`.`BlockID` AS `BlockID`
FROM ((`eyetracking`.`Blocks` `a`
       LEFT JOIN `l2t`.`ChildStudy` `c` ON ((`a`.`ChildStudyID` = `c`.`ChildStudyID`)))
      LEFT JOIN `l2t`.`Study` `d` ON ((`c`.`StudyID` = `d`.`StudyID`)))
ORDER BY `a`.`Block_Basename`;


ALTER ALGORITHM = UNDEFINED VIEW `q_BlockAttributesByStudy` AS
SELECT `a`.`Study` AS `Study`,
       `a`.`ResearchID` AS `ResearchID`,
       `a`.`Task` AS `Task`,
       `a`.`Version` AS `Version`,
       `a`.`Basename` AS `Basename`,
       `a`.`DateTime` AS `DateTime`,
       `a`.`BlockID` AS `BlockID`,
       `b`.`BlockAttribute_Name` AS `BlockAttribute_Name`,
       `b`.`BlockAttribute_Value` AS `BlockAttribute_Value`
FROM (`eyetracking`.`q_BlocksByStudy` `a`
      LEFT JOIN `eyetracking`.`BlockAttributes` `b` on((`a`.`BlockID` = `b`.`BlockID`)))
ORDER BY `a`.`Basename` ;


ALTER ALGORITHM = UNDEFINED VIEW `q_TrialsByStudy` AS
SELECT `a`.`Study` AS `Study`,
       `a`.`ResearchID` AS `ResearchID`,
       `a`.`Task` AS `Task`,
       `a`.`Version` AS `Version`,
       `a`.`Basename` AS `Basename`,
       `a`.`DateTime` AS `DateTime`,
       `a`.`BlockID` AS `BlockID`,
       `b`.`TrialID` AS `TrialID`,
       `b`.`Trial_TrialNo` AS `TrialNo`
FROM (`eyetracking`.`q_BlocksByStudy` `a`
      LEFT JOIN `eyetracking`.`Trials` `b` on((`a`.`BlockID` = `b`.`BlockID`)))
ORDER BY `a`.`Basename`,
         `b`.`Trial_TrialNo` ;


ALTER ALGORITHM = UNDEFINED VIEW `q_TrialAttributesByStudy` AS
SELECT `a`.`Study` AS `Study`,
       `a`.`ResearchID` AS `ResearchID`,
       `a`.`Task` AS `Task`,
       `a`.`Version` AS `Version`,
       `a`.`Basename` AS `Basename`,
       `a`.`DateTime` AS `DateTime`,
       `a`.`BlockID` AS `BlockID`,
       `b`.`TrialID` AS `TrialID`,
       `a`.`TrialNo` AS `TrialNo`,
       `b`.`TrialAttribute_Name` AS `TrialAttribute_Name`,
       `b`.`TrialAttribute_Value` AS `TrialAttribute_Value`
FROM (`eyetracking`.`q_TrialsByStudy` `a`
      LEFT JOIN `eyetracking`.`TrialAttributes` `b` on((`a`.`TrialID` = `b`.`TrialID`)))
ORDER BY `a`.`Basename`,
         `a`.`TrialNo`,
         `b`.`TrialAttribute_Name` ;


ALTER ALGORITHM = UNDEFINED VIEW `q_LooksByStudy` AS
SELECT `a`.`Study` AS `Study`,
       `a`.`ResearchID` AS `ResearchID`,
       `a`.`Task` AS `Task`,
       `a`.`Version` AS `Version`,
       `a`.`Basename` AS `Basename`,
       `a`.`DateTime` AS `DateTime`,
       `a`.`BlockID` AS `BlockID`,
       `b`.`TrialID` AS `TrialID`,
       `a`.`TrialNo` AS `TrialNo`,
       `b`.`Time` AS `Time`,
       `b`.`XMean` AS `XMean`,
       `b`.`YMean` AS `YMean`,
       `b`.`GazeByImageAOI` AS `GazeByImageAOI`,
       `b`.`GazeByAOI` AS `GazeByAOI`
FROM (`eyetracking`.`q_TrialsByStudy` `a`
      LEFT JOIN `eyetracking`.`Looks` `b` on((`a`.`TrialID` = `b`.`TrialID`)))
ORDER BY `a`.`Basename`,
         `a`.`TrialNo`,
         `b`.`Time` ;
