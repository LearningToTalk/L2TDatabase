# Add tp1 LENA information to the database

library("dplyr")
library("L2TDatabase")
library("stringr")
library("rio")
source("inst/paths.R")

# Load TP1 hours
t1 <- import(paths$tp1_lenas) %>%
  as_data_frame %>%
  rename(ShortResearchID = Subject)
glimpse(t1)

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Use ShortResearchID and Study columns to get ChildStudyID
cds <- left_join(l2t_dl$ChildStudy, l2t_dl$Study)
cds

t1_expanded <- inner_join(t1, cds)
glimpse(t1_expanded)

# Keep just the columns in the LENA_Admin table. Since there are several hours
# per admin, use `distinct` to get one row per admin
admins <- l2t_dl$LENA_Admin
t1_admins <- t1_expanded %>%
  match_columns(admins) %>%
  distinct

n_distinct(t1_admins$ChildStudyID)
nrow(t1_admins)

# NB: The remote table has a Notes column, whereas the local copy doesn't. This
# doesn't affect the anti_join below. If the two did have Notes columns that
# disagreed, then duplicated data could make its way to the database.
admins
t1_admins

# Remove duplicated data.
t1_admins <- anti_join(t1_admins, admins) %>%
  arrange(ChildStudyID, LENADate)
t1_admins

# Update db
l2t_write <- l2t_writer_connect("inst/l2t_db.cnf")
append_rows_to_table(l2t_write, "LENA_Admin", t1_admins)

# Add local hourly data to remote admin table
lena_admins <- collect("LENA_Admin" %from% l2t)
with_hours <- inner_join(lena_admins, t1)

# Keep just the columns in the LENA_Hours tbl
db_hours <- l2t_dl$LENA_Hours
with_hours <- match_columns(with_hours, db_hours)

# Make sure the local Hour and the remote Hour columns have the same formatting
# for the anti_join to work. Assume either Y-M-D H:M or Y-M-D H:M:S, convert to
# date objects, convert back to Y-M-D H:M:S strings.

library("lubridate")
db_hours$Hour <- db_hours$Hour %>%
  parse_date_time(orders = c("%Y%m%d %H%M%S", "%Y%m%d %H%M")) %>%
  format

with_hours$Hour <- with_hours$Hour %>%
  parse_date_time(orders = c("%Y%m%d %H%M%S", "%Y%m%d %H%M")) %>%
  format

# Remove duplicated rows
t1_hours <- anti_join(with_hours, db_hours, by = c("LENAID", "Hour")) %>%
  arrange(LENAID, Hour)
t1_hours

# Update db
append_rows_to_table(l2t_write, "LENA_Hours", t1_hours)

