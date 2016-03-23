--
-- Create a view to display overall LENA averages
--

CREATE ALGORITHM = UNDEFINED VIEW `q_LENA_Averages`
AS SELECT c.Study, d.ShortResearchID AS  `ResearchID` , b.LENA_Date,
  sum(a.Duration) / 3600  AS  `LENA_Hours`,
  sum(a.Meaningful) / sum(a.Duration) AS  `Prop_Meaningful`,
  sum(a.Distant) / sum(a.Duration) AS  `Prop_Distant`,
  sum(a.TV) / sum(a.Duration) AS  `Prop_TV`,
  sum(a.Noise) / sum(a.Duration) AS  `Prop_Noise`,
  sum(a.Silence) / sum(a.Duration) AS  `Prop_Silence`,
  sum(a.AWC_Actual) / (sum(a.Duration) / 3600) AS `AWC_Hourly`,
  sum(a.CTC_Actual) / (sum(a.Duration) / 3600) AS `CTC_Hourly`,
  sum(a.CVC_Actual) / (sum(a.Duration) / 3600) AS `CVC_Hourly`,
  TIME_FORMAT(min(a.Hour), '%h:%m %p') as FirstHour,
  TIME_FORMAT(max(a.Hour), '%h:%m %p') as FinalHour,
  -- if recording spans two days, give Hours After Midnight as 1 plus last hour
  -- sampled (midnight has an hour of 0)
  IF( COUNT(DISTINCT DAY(a.Hour)) = 2, HOUR(max(a.Hour)) + 1, 0) as HoursAfterMidnight,
  b.LENA_Notes as `LENA_Notes`
FROM ChildStudy d
LEFT JOIN Study c
USING ( StudyID )
LEFT JOIN LENA_Admin b
USING ( ChildStudyID )
LEFT JOIN LENA_Hours a
USING ( LENAID )
WHERE b.LENA_Date IS NOT NULL
GROUP BY b.LENAID
ORDER BY b.ChildStudyID
