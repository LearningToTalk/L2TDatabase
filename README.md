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
#> [1] "Child"             "ChildStudy"        "LENA_Admin"       
#> [4] "MinPair_Admin"     "MinPair_Responses" "Notes"            
#> [7] "Scores_TimePoint1" "Study"             "StudyTask"

# use tbl to create a link to a tbl in the database
studies <- tbl(src = l2t, "Study") 
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
#> Writing inst/backup/2015_06_29/Child.csv
#> Writing inst/backup/2015_06_29/ChildStudy.csv
#> Writing inst/backup/2015_06_29/LENA_Admin.csv
#> Writing inst/backup/2015_06_29/MinPair_Admin.csv
#> Writing inst/backup/2015_06_29/MinPair_Responses.csv
#> Writing inst/backup/2015_06_29/Notes.csv
#> Writing inst/backup/2015_06_29/Scores_TimePoint1.csv
#> Writing inst/backup/2015_06_29/Study.csv
#> Writing inst/backup/2015_06_29/StudyTask.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
rows <- lapply(all_tbls, nrow)
data_frame(tbl = names(rows), rows = unlist(rows))
#> Source: local data frame [9 x 2]
#> 
#>                 tbl rows
#> 1             Child  224
#> 2        ChildStudy  224
#> 3        LENA_Admin    0
#> 4     MinPair_Admin  190
#> 5 MinPair_Responses 7508
#> 6             Notes    6
#> 7 Scores_TimePoint1    0
#> 8             Study    3
#> 9         StudyTask   12

all_tbls$ChildStudy
#> Source: local data frame [224 x 6]
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
#> Variables not shown: ChildStudy_TimeStamp (chr)
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
#> [1] "TestWrites"

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
#> 1            4  Hello!  2015-06-29 14:25:52
```
