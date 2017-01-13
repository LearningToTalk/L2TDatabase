--
-- Create a view to display overall LENA averages
--

create or replace algorithm = undefined view backend.q_LENA_Averages as
  select
    childstudy.ChildStudyID,
    study.Study,
    childstudy.ShortResearchID as ResearchID,
    recording.LENA_Date as LENA_Completion,
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
    recording.LENAID;


-- user-facing version
create or replace algorithm = undefined view l2t.LENA_Averages as
  select
    Study,
    ResearchID,
    LENA_Completion,
    LENA_FirstHour,
    LENA_FinalHour,
    LENA_Hours,
    LENA_Prop_Meaningful,
    LENA_Prop_Distant,
    LENA_Prop_TV,
    LENA_Prop_Noise,
    LENA_Prop_Silence,
    LENA_AWC_Hourly,
    LENA_CTC_Hourly,
    LENA_CVC_Hourly,
    LENA_Notes
  from
    backend.q_LENA_Averages
  order by
    Study,
    ResearchID;
