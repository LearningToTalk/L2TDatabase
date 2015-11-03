# Compute hourly LENA averages

library("L2TDatabase")
library("dplyr")
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)

# Combine child-study-childstudy tbls
cds <- tbl(l2t, "Child") %>%
  left_join("ChildStudy" %from% l2t) %>%
  left_join("Study" %from% l2t) %>%
  filter(Study == "TimePoint1")

# Combine lena tables (hourly data with administration info)
lena_data <- tbl(l2t, "LENA_Admin") %>%
  left_join("LENA_Hours" %from% l2t)

describe_tbl(l2t, "LENA_Hours")


# Keep just hours for timepoint 1 kids and download from db
d_all <- inner_join(cds, lena_data) %>% collect

# Keep just the administration notes
d_notes <- d_all %>% select(LENAID, LENANotes = Notes) %>% distinct

# Collapse across hours
d_sum <- d_all %>%
  group_by(Study, ShortResearchID, LENAID) %>%
  summarise_each(funs(sum), Duration:CVC_Actual) %>%
  ungroup %>%
  # Create helpful measures
  mutate(Hours = Duration / 3600,
         Prop_Meaningful = Meaningful / Duration,
         Prop_Distant = Distant / Duration,
         Prop_TV = TV / Duration,
         Prop_Noise = Noise / Duration,
         Prop_Silence = Silence / Duration,
         AWC_Hourly = AWC_Actual / Hours,
         CTC_Hourly = CTC_Actual / Hours,
         CVC_Hourly = CVC_Actual / Hours) %>%
  select(-(Duration:CVC_Actual))

d_final <- d_sum %>%
  filter(10 <= Hours) %>%
  left_join(d_notes) %>%
  select(-LENAID) %>%
  rename(ResearchID = ShortResearchID)

readr::write_csv(d_final, "inst/export/exports/lena_tp1.csv")
