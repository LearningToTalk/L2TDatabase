Migration Scripts
=================

These R scripts migrated our data from the various csvs and Excel spreadsheets 
into the database. They are included here to document how the data were cleaned 
and inserted to the database. They are not meant to be re-used in order to add
new data to the database.


Migration Boilerplate
---------------------

Importing data into the database follows a basic recipe. In short, we have to: 

* load the data to be migrated
* make it match the column names, data formats and identifier keys of the 
  destination table 
* filter out values that should not be migrated 
* update the remote table

Here is some boilerplate R code for writing a migration script:

```r
## Preamble
library("L2TDatabase")
library("rio")
library("dplyr")
library("tidyr")
library("stringr")

# A non-version-controlled file containing paths to the source data
source("inst/paths.R")
data_path <- paths[["_______"]]

# A non-version-controlled file with db connection info and credentials
cnf_file <- file.path(getwd(), "inst/l2t_db.cnf")

# Other parameters for migration
db_name <- "l2t"
backup_dir <- "inst/backup"
dest_table <- "_________"


## Download/backup db beforehand

# Connect and download each table to csv
l2t <- l2t_connect(cnf_file, db_name)
l2t_dl <- l2t_backup(l2t, backup_dir)

# If MySQL is available on the command line, dump the database too
dump_database(cnf_file, backup_dir, db_name)


## Prepare the data that will be imported
d <- import(data_path)
str(d)

# Combine Child-Study-ChildStudy tbls to get identifiers used by the database
cds <- l2t_dl$ChildStudy %>%
  left_join(l2t_dl$Study) %>%
  left_join(l2t_dl$Child)
cds

# Attach the database identifiers to the scores
d$Study <- "write some code to create this column"
d$ShortResearchID <- "write some code to create this column"
with_ids <- left_join(d, cds, by = c("Study", "ShortResearchID"))

# Prep the data to match the formatting of the destination table.
# ...
# E.g. filter out TBD blank scores, make columns names match those in
# destination, use same coding of gender or dialect as target
# ...


## Compare local table with remote table and update database

# Subtract current rows from new rows to see what data is new
current_rows <- collect(dest_table %from% l2t)
new_rows <- anti_join(with_ids, current_rows)

# Other comparisons to make between the local and remote tables
# ...

# Choose final columns and update rows
to_add <- match_columns(new_rows, current_rows) %>%
  arrange(ChildStudyID)
to_add

# Add to database
append_rows_to_table(l2t, dest_table, to_add)


## Compare remote to local
updated_rows <- anti_join(to_add, collect(dest_table %from% l2t))
updated_rows


# Other checks to run on the remote table
# ...
```
