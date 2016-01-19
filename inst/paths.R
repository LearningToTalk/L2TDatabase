# Load paths to other resources

library("dplyr")
library("L2TDatabase")
cnf_file <- "inst/l2t_db.cnf"
db_backstage <- l2t_connect(cnf_file, "l2tBackstage")


## Workflow to add new paths to the database

# # The new paths should be stored in a list
# paths_to_add <- list(
#   PathKey1 = "value",
#   PathKey2 = "value"
# )
# paths_to_add <- paths
#
# # ...which we convert to a data-frame
# df_paths_to_add <- data_frame(
#   PathKey = names(paths_to_add),
#   PathValue = unlist(paths_to_add))
#
# # Get current paths
# df_current_paths <- db_backstage %>%
#   tbl("LocalPaths") %>%
#   collect
#
# # Keep just the new rows
# df_new_paths_to_add <- anti_join(df_paths_to_add, df_current_paths)
#
# # Keep just the columns with a counterpart in the remote table
# df_new_paths_to_add <- match_columns(df_new_paths_to_add, df_current_paths)
#
# # Add the new paths
# append_rows_to_table(
#   src = db_backstage,
#   tbl_name = "LocalPaths",
#   rows = df_new_paths_to_add)


# Download the paths and store in a list
df_current_paths <- db_backstage %>%
  tbl("LocalPaths") %>%
  collect

paths <- structure(
  .Data = as.list(df_current_paths$PathValue),
  names = df_current_paths$PathKey)

# Disconnect db and remove data-frames
invisible(RMySQL::dbDisconnect(db_backstage$con))
rm(db_backstage)
rm(df_current_paths)
