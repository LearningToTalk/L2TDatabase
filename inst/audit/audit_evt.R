# Check for inconsistencies in the EVT scores in the database

library("L2TDatabase")
library("dplyr")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

evts <- left_join(cds, l2t_dl$EVT) %>%
  select(Study, ID = ShortResearchID, EVT_Form:EVT_Age)

with_scores <- evts %>%
  filter(!is.na(EVT_Raw))

missing_dates <- with_scores %>%
  filter(is.na(EVT_Completion))
missing_dates

missing_forms <- with_scores %>%
  filter(is.na(EVT_Form)) %>%
  arrange(Study, ID)

as.data.frame(missing_forms)

# Get dates and ages
ages <- left_join(cds, l2t_dl$EVT) %>%
  select(Study, ShortResearchID, Birthdate, EVT_Completion, EVT_Age) %>%
  filter(!is.na(EVT_Completion))

# Compute chronological age
ages <- ages %>%
  rowwise %>%
  mutate(ChronoAge = chrono_age(Birthdate, EVT_Completion)) %>%
  ungroup

ages %>% filter(EVT_Age != ChronoAge)




# Check scores against norms
evt_norms <- l2t_connect(cnf_file, "norms") %>% tbl("EVT2") %>% collect

# Make a form of the table amenable for score checking
norm_check <- with_scores %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(EVT_Age < 30, 30, EVT_Age)) %>%
  rename(Raw = EVT_Raw, TestAge = EVT_Age,
         OurStnd = EVT_Standard, OurGSV = EVT_GSV)

# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(EVT_Form %in% "A") %>%
  left_join(evt_norms) %>%
  rename() %>%
  select(Study:EVT_Completion, TestAge, NormAge = Age, AgePage,
         Raw, OurStnd, Stnd, OurGSV, GSV)

# Look for Form Bs
norm_check %>%
  filter(EVT_Form == "B")

# Check GSVs
form_a %>% filter(OurGSV != GSV)

# Check Standard Scores
form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID) %>% as.data.frame

# Try to checks score where we don't know the form
form_na <- norm_check %>%
  filter(is.na(EVT_Form)) %>%
  left_join(evt_norms) %>%
  rename() %>%
  select(Study:EVT_Completion, TestAge, NormAge = Age, AgePage,
         Raw, OurStnd, Stnd, OurGSV, GSV)

# Check GSVs
form_na %>% filter(OurGSV != GSV)

# Check Standard Scores
form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)


