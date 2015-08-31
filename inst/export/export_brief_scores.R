# Bundle up BRIEF scores from the database

library("L2TDatabase")
library("dplyr")
library("stringr")

cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")


# Combine child-study-childstudy tbls
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child) %>%
  left_join(l2t_dl$BRIEF)

scores <- cds %>%
  select(ResearchID = ShortResearchID, Inhibit_Raw:BRIEF_Note) %>%
  filter(!is.na(Inhibit_Raw)) %>%
  arrange(ResearchID)

readr::write_csv(scores, "inst/export/exports/brief_scores.csv")

brief_codebook <- describe_tbl(l2t, "BRIEF") %>%
  filter(is.element(Field, names(scores))) %>%
  select(Field, Description)
readr::write_csv(brief_codebook, "inst/export/exports/brief_codebook.csv")
