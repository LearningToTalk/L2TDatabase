--
-- Create a view to display overall LENA averages
--

create or replace algorithm = undefined view l2t.LENA_Averages as
  select
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    recording.LENA_Date,
    time_format(min(hours.Hour), '%h:%m %p') as LENA_FirstHour,
    time_format(max(hours.Hour), '%h:%m %p') as LENA_FinalHour,
    sum(hours.Duration) / 3600 as LENA_Hours,
    sum(hours.Meaningful) / sum(hours.Duration) as LENA_Prop_Meaningful,
    sum(hours.Distant) / sum(hours.Duration) as LENA_Prop_Distant,
    sum(hours.TV) / sum(hours.Duration) as LENA_Prop_TV,
    sum(hours.Noise) / sum(hours.Duration) as LENA_Prop_Noise,
    sum(hours.Silence) / sum(hours.Duration) as LENA_Prop_Silence,
    sum(hours.AWC_Actual) / (sum(hours.Duration) / 3600) as LENA_AWC_Hourly,
    sum(hours.CTC_Actual) / (sum(hours.Duration) / 3600) as LENA_CTC_Hourly,
    sum(hours.CVC_Actual) / (sum(hours.Duration) / 3600) as LENA_CVC_Hourly,
    recording.LENA_Notes as LENA_Notes
  from
    backend.ChildStudy childstudy
    left join backend.Study study
      using (StudyID)
    left join backend.LENA_Admin recording
      using (ChildStudyID)
    left join backend.LENA_Hours hours
      using (LENAID)
  where
    -- compute averages/sums only for LENA hourly measurements from 6AM to 11PM
    recording.LENA_Date is not null and
    hour(hours.Hour) between 6 and 22
  group by
    recording.LENAID
  order by
    study.Study,
    childstudy.ShortResearchID;
