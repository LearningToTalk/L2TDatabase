# Seed the SES table with children
library("L2TDatabase")
library("dplyr")

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Find children not yet in SES table
new_children <- anti_join(l2t_dl$Child, l2t_dl$SES) %>%
  select(ChildID) %>%
  mutate(SES_Notes = "Entry seeded. Need to enter data")

# Update the remote table. An error here is a good thing if there are no new
# rows to add.
append_rows_to_table(l2t, "SES", new_children)
