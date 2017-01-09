# Add LENA information to the database

library("dplyr")
library("L2TDatabase")
library("stringr")
source("inst/paths.R")

# Find all csvs in folder that contains the TP1 LENA csv
csvs <- list.files(
  dirname(paths$tp1_lenas),
  pattern = "_hourly.csv",
  full.names = TRUE)

load_lena_csv <- . %>% readr::read_csv() %>% rename(ShortResearchID = Subject)

lena_csvs <- csvs %>% lapply(load_lena_csv)
lena_csvs

# Download/backup db beforehand
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
l2t_dl <- l2t_backup(l2t, "inst/backup")

# Use ShortResearchID and Study columns to get ChildStudyID
df_cds <- left_join(l2t_dl$ChildStudy, l2t_dl$Study)
df_cds

df_lena_hours <- lena_csvs %>%
  bind_rows() %>%
  left_join(df_cds) %>%
  rename(LENA_Date = LENADate)
df_lena_hours

# Keep just the columns in the LENA_Admin table. Since there are several hours
# per admin, use `distinct` to get one row per admin
df_remote_admins <- l2t_dl$LENA_Admin %>% readr::type_convert()
df_local_admins <- df_lena_hours %>%
  match_columns(df_remote_admins) %>%
  distinct()

n_distinct(df_local_admins$ChildStudyID)
nrow(df_local_admins)

# NB: The remote table has a Notes column, whereas the local copy doesn't. This
# doesn't affect the anti_join below. If the two did have Notes columns that
# disagreed, then duplicated data could make its way to the database.
df_remote_admins
df_local_admins

# Remove duplicated data.
df_local_admins_to_add <- df_local_admins %>%
  anti_join(df_remote_admins) %>%
  arrange(ChildStudyID, LENA_Date)
df_local_admins_to_add


# Update db
append_rows_to_table(l2t, "LENA_Admin", df_local_admins_to_add)





## Find records that need to be updated

# Redownload the table
df_remote_admins <- tbl(l2t, "LENA_Admin") %>%
  collect()

df_remote_admins %>%
  count(ChildStudyID) %>%
  filter(n != 1)

# Attach the database keys to latest data
df_remote_admins_indices <- df_remote_admins %>%
  select(ChildStudyID, LENAID)

df_local <- df_local_admins %>%
  inner_join(df_remote_admins_indices) %>%
  arrange(LENAID) %>%
  mutate(LENA_Date = format(LENA_Date))

# Keep just the columns in the latest data
df_remote_admins <- match_columns(df_remote_admins, df_local) %>%
  filter(ChildStudyID %in% df_local$ChildStudyID) %>%
  arrange(LENAID)

# Preview changes with daff
library("daff")
daff <- diff_data(df_remote_admins, df_local, context = 0)
stamp <- format(Sys.time(), "%Y-%m-%d_%H-%M")
render_diff(daff)

anti_join(df_local, df_remote_admins)
anti_join(df_remote_admins, df_local)

# Here we would update the remote table with any changes if needed

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote_admins, "LENAID")

overwrite_rows_in_table(l2t, "LENA_Admin", rows = df_local, preview = TRUE)
# overwrite_rows_in_table(l2t, "LENA_Admin", rows = df_local, preview = FALSE)




# Add local hourly data to remote admin table
df_remote_admins <- collect("LENA_Admin" %from% l2t) %>%
  readr::type_convert()

df_with_hours <- df_remote_admins %>%
  inner_join(df_lena_hours)

# Keep just the columns in the LENA_Hours tbl
df_remote_hours <- collect("LENA_Hours" %from% l2t)
df_with_hours <- match_columns(df_with_hours, df_remote_hours)

# Make sure the local Hour and the remote Hour columns have the same formatting
# for the anti_join to work. Assume either Y-M-D H:M or Y-M-D H:M:S, convert to
# date objects, convert back to Y-M-D H:M:S strings.

library("lubridate")
df_remote_hours$Hour <- df_remote_hours$Hour %>%
  parse_date_time(orders = c("%Y%m%d %H%M%S", "%Y%m%d %H%M"), tz = "America/Chicago") %>%
  format()

df_with_hours$Hour <- df_with_hours$Hour %>%
  parse_date_time(orders = c("%Y%m%d %H%M%S", "%Y%m%d %H%M"), tz = "America/Chicago") %>%
  format

# Remove duplicated rows
df_new_hours <- df_with_hours %>%
  anti_join(df_remote_hours, by = c("LENAID", "Hour")) %>%
  arrange(LENAID, Hour)
df_new_hours

# Update the remote table. An error here is a good thing if there are no new
# rows to add
append_rows_to_table(l2t, "LENA_Hours", df_new_hours)



## Find records that need to be updated

# Redownload the table
df_remote_hours <- tbl(l2t, "LENA_Hours") %>%
  collect()

# Attach the database keys to latest data
df_remote_hours_indices <- df_remote_hours %>%
  select(LENAHourID, LENAID, Hour)

df_local <- df_with_hours %>%
  left_join(df_remote_hours_indices) %>%
  arrange(LENAID, LENAHourID)

# Keep just the columns in the latest data
df_remote_hours <- match_columns(df_remote_hours, df_local) %>%
  arrange(LENAID, LENAHourID)

# Preview changes with daff
daff <- diff_data(df_remote_hours, df_local, context = 0)
render_diff(daff)

anti_join(df_local, df_remote_hours)
anti_join(df_remote_hours, df_local)

# Here we would update the remote table with any changes if needed

# Or see them itemized in a long data-frame
create_diff_table(df_local, df_remote_hours, "LENAHourID")

overwrite_rows_in_table(l2t, "LENA_Hours", rows = df_local, preview = TRUE)
# overwrite_rows_in_table(l2t, "LENA_Admin", rows = df_local, preview = FALSE)


