<!-- README.md is generated from README.Rmd. Please edit that file -->
L2TDatabase
===========

This R package contains helper functions for working with the MySQL database for the [Learning To Talk](http://learningtotalk.org) project.

Connections to the database are managed by [.cnf files](http://svitsrv25.epfl.ch/R-doc/library/RMySQL/html/RMySQL-package.html). This package provides `make_cnf_file` which creates a cnf file from login and connection information.

``` r
library("L2TDatabase")

# initialze a cnf file using all default (empty) values
make_cnf_file()
#> Writing to db.cnf:
#> [client]
#> user=
#> password=
#> host=
#> port=3306
#> 
#> [rs-dbi]
#> database=

# all values filled
make_cnf_file(dest = "my_connection.cnf", user = "tj", password = "", 
              db = "my_db", host = "localhost", port = 3306)
#> Writing to my_connection.cnf:
#> [client]
#> user=tj
#> password=
#> host=localhost
#> port=3306
#> 
#> [rs-dbi]
#> database=my_db
```

Once we've create a .cnf file, we can connect to the database using `l2t_connect`. We can view the names of all the tables in the database with `dplyr::src_tbls`. See the dplyr [vignette on databases](http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html) for how to work with remotely stored data using dplyr; it's really great stuff.

``` r
library("dplyr", warn.conflicts = FALSE)

# connect to the database
l2t <- l2t_connect(cnf_file)

# list all the tbls in the database
src_tbls(l2t)
#>  [1] "Child"             "ChildStudy"        "EVT"              
#>  [4] "LENA_Admin"        "LENA_Hours"        "Literacy"         
#>  [7] "MinPair_Admin"     "MinPair_Responses" "Notes"            
#> [10] "SES"               "Scores_TimePoint1" "Study"            
#> [13] "StudyTask"

# use tbl to create a link to a tbl in the database
studies <- tbl(src = l2t, "Study") 
head(studies)
#>   StudyID      Study Code     Study_TimeStamp
#> 1       1 TimePoint1    L 2015-06-26 14:44:06
#> 2       2 TimePoint2    L 2015-06-26 14:44:06
#> 3       3 TimePoint3    L 2015-06-26 14:44:06

# or use %from% as an infix form of the above
studies <- "Study" %from% l2t
head(studies)
#>   StudyID      Study Code     Study_TimeStamp
#> 1       1 TimePoint1    L 2015-06-26 14:44:06
#> 2       2 TimePoint2    L 2015-06-26 14:44:06
#> 3       3 TimePoint3    L 2015-06-26 14:44:06
```

We can download and backup each table in the database with `l2t_backup`.

``` r
# backup each tbl
backup_dir <- "inst/backup"
all_tbls <- l2t_backup(l2t, backup_dir)
#> Writing inst/backup/2015_07_07/Child.csv
#> Writing inst/backup/2015_07_07/ChildStudy.csv
#> Writing inst/backup/2015_07_07/EVT.csv
#> Writing inst/backup/2015_07_07/LENA_Admin.csv
#> Writing inst/backup/2015_07_07/LENA_Hours.csv
#> Writing inst/backup/2015_07_07/Literacy.csv
#> Writing inst/backup/2015_07_07/MinPair_Admin.csv
#> Writing inst/backup/2015_07_07/MinPair_Responses.csv
#> Writing inst/backup/2015_07_07/Notes.csv
#> Writing inst/backup/2015_07_07/SES.csv
#> Writing inst/backup/2015_07_07/Scores_TimePoint1.csv
#> Writing inst/backup/2015_07_07/Study.csv
#> Writing inst/backup/2015_07_07/StudyTask.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
rows <- lapply(all_tbls, nrow)
data_frame(tbl = names(rows), rows = unlist(rows))
#> Source: local data frame [13 x 2]
#> 
#>                  tbl rows
#> 1              Child  224
#> 2         ChildStudy  224
#> 3                EVT    0
#> 4         LENA_Admin  182
#> 5         LENA_Hours 2968
#> 6           Literacy    0
#> 7      MinPair_Admin  190
#> 8  MinPair_Responses 7508
#> 9              Notes    6
#> 10               SES    0
#> 11 Scores_TimePoint1    0
#> 12             Study    3
#> 13         StudyTask   12

all_tbls$ChildStudy
#> Source: local data frame [224 x 8]
#> 
#>    ChildStudyID ChildID StudyID ShortResearchID FullResearchID
#> 1             1      23       1            600L      600L37MS2
#> 2             2      24       1            601L      601L28MS1
#> 3             3      25       1            602L      602L34MS2
#> 4             4      26       1            603L      603L35FS2
#> 5             5      27       1            604L      604L30FS1
#> 6             6      28       1            605L      605L31MS1
#> 7             7      29       1            606L      606L28MS1
#> 8             8      30       1            607L      607L36MS2
#> 9             9      31       1            608L      608L39FS2
#> 10           10      32       1            609L      609L28MS1
#> ..          ...     ...     ...             ...            ...
#> Variables not shown: ChildStudy_TimeStamp (chr), Exclude (int),
#>   ExcludeNotes (chr)
```

Writing
-------

dplyr provides read-only access to a database, so we can't accidentally do stupid things to our data. In order to write to the database in R, we have use the interface provided by the package RMySQL. We connect to the database using `l2t_connect_writer`. For the purposes of this demo, we will work on the separate `l2t_test` database.

``` r
library("RMySQL")
#> Loading required package: DBI
l2t_write <- l2t_writer_connect(cnf_file, db_name = "l2ttest")

# Table listing
dbListTables(l2t_write)
#> [1] "ChildTest"  "TestWrites"

# Before writing
dbReadTable(l2t_write, "TestWrites")
#> [1] TestWritesID         Message              TestWrites_TimeStamp
#> <0 rows> (or 0-length row.names)

# Add rows to table
append_rows_to_table(
  db_con = l2t_write, 
  tbl_name = "TestWrites", 
  rows = data_frame(Message = "Hello!"))
#> [1] TRUE

# After writing
dbReadTable(l2t_write, "TestWrites")
#>   TestWritesID Message TestWrites_TimeStamp
#> 1            3  Hello!  2015-07-07 11:59:41
```

Helpers
-------

This package also provides some helper functions for working with our data. `undo_excel_date` converts Excel's dates into R dates. `chrono_age` computes the number of months (rounded down) between two dates, as you would when computing chronological age.

``` r
# Create a date and another 18 months later
dates <- list()
dates$t1 <- undo_excel_date(41659)
dates$t2 <- undo_excel_date(41659 + 365 + 181)
str(dates)
#> List of 2
#>  $ t1: POSIXct[1:1], format: "2014-01-20"
#>  $ t2: POSIXct[1:1], format: "2015-07-20"

# Chrono age in months, assuming t1 is a birthdate
chrono_age(dates$t2, dates$t1)
#> [1] 18

# More chrono_age examples
chrono_age("2014-01-20", "2012-01-20")
#> [1] 24
chrono_age("2014-01-20", "2011-12-20")
#> [1] 25
chrono_age("2014-01-20", "2011-11-20")
#> [1] 26
```
