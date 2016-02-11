# Check for inconsistencies in the PPVT scores in the database

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

ppvts <- left_join(cds, l2t_dl$PPVT) %>%
  select(Study, ID = ShortResearchID, PPVT_Form:PPVT_Age)

with_scores <- ppvts %>%
  filter(!is.na(PPVT_Raw))

missing_dates <- with_scores %>%
  filter(is.na(PPVT_Completion))
missing_dates

missing_forms <- with_scores %>%
  filter(is.na(PPVT_Form)) %>%
  arrange(Study, ID)

as.data.frame(missing_forms)

# Get dates and ages
ages <- left_join(cds, l2t_dl$PPVT) %>%
  select(Study, ShortResearchID, Birthdate, PPVT_Completion, PPVT_Age) %>%
  filter(!is.na(PPVT_Completion))

# Compute chronological age
ages <- ages %>%
  rowwise %>%
  mutate(ChronoAge = chrono_age(Birthdate, PPVT_Completion)) %>%
  ungroup

ages %>% filter(PPVT_Age != ChronoAge)




# Check scores against norms
ppvt_norms <- l2t_connect(cnf_file, "norms") %>% tbl("PPVT4") %>% collect

# Make a form of the table amenable for score checking
norm_check <- with_scores %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(PPVT_Age < 30, 30, PPVT_Age)) %>%
  rename(Raw = PPVT_Raw, TestAge = PPVT_Age,
         OurStnd = PPVT_Standard, OurGSV = PPVT_GSV)

# Look for Form Bs
norm_check %>%
  filter(PPVT_Form == "B")

# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(PPVT_Form %in% "A") %>%
  left_join(ppvt_norms) %>%
  rename() %>%
  select(Study:PPVT_Completion, NormAge = Age, AgePage,
         Raw, OurStnd, Stnd, OurGSV, GSV)

# Check GSVs
form_a %>% filter(OurGSV != GSV)

# Check Standard Scores
form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)

# Try to checks score where we don't know the form
form_na <- norm_check %>%
  filter(is.na(PPVT_Form)) %>%
  left_join(ppvt_norms) %>%
  rename() %>%
  select(Study:PPVT_Completion, NormAge = Age, AgePage,
         Raw, OurStnd, Stnd, OurGSV, GSV)

# Check GSVs
form_na %>% filter(OurGSV != GSV)

# Check Standard Scores
form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)


