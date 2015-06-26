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
#> [4] "MinPair_Admin"     "MinPair_Mean"      "MinPair_Responses"
#> [7] "Scores_TimePoint1" "Study"             "StudyTask"

# use tbl to create a link to a tbl in the database
studies <- tbl(src = l2t, "Study") 
head(studies)
#>   StudyID      Study     Study_TimeStamp
#> 1       1 TimePoint1 2015-04-22 19:04:22
#> 2       2 TimePoint2 2015-04-22 19:04:44
#> 3       3 TimePoint3 2015-04-22 19:05:47
```

We can download and backup each table in the database with `l2t_backup`.

``` r
# backup each tbl
backup_dir <- "inst/backup"
all_tbls <- l2t_backup(l2t, backup_dir)
#> Writing inst/backup/2015_06_26/Child.csv
#> Writing inst/backup/2015_06_26/ChildStudy.csv
#> Writing inst/backup/2015_06_26/LENA_Admin.csv
#> Writing inst/backup/2015_06_26/MinPair_Admin.csv
#> Writing inst/backup/2015_06_26/MinPair_Mean.csv
#> Writing inst/backup/2015_06_26/MinPair_Responses.csv
#> Writing inst/backup/2015_06_26/Scores_TimePoint1.csv
#> Writing inst/backup/2015_06_26/Study.csv
#> Writing inst/backup/2015_06_26/StudyTask.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
all_tbls$Study
#> Source: local data frame [3 x 3]
#> 
#>   StudyID      Study     Study_TimeStamp
#> 1       1 TimePoint1 2015-04-22 19:04:22
#> 2       2 TimePoint2 2015-04-22 19:04:44
#> 3       3 TimePoint3 2015-04-22 19:05:47
```

Writing
-------

dplyr provides read-only access to a database, so we can't accidentally do stupid things to our data. In order to write to the database in R, we have use the interface provided by the package RMySQL. We connect to the database using `l2t_connect_writer`. For the purposes of this demo, we will work on the separate `l2t_test` database.

``` r
library("RMySQL")
#> Loading required package: DBI
l2t_write <- l2t_writer_connect(cnf_file, db_name = "l2t_test")

# Table listing
dbListTables(l2t_write)
#> [1] "TestWrites"

# Before writing
dbReadTable(l2t_write, "TestWrites")
#>   TestWrite_TimeStamp TestWritesID Message
#> 1 2015-06-26 12:32:03            4  Hello!

# Add rows to table
append_rows_to_table(
  db_con = l2t_write, 
  tbl_name = "TestWrites", 
  rows = data_frame(Message = "Hello!"))
#> [1] TRUE

# After writing
dbReadTable(l2t_write, "TestWrites")
#>   TestWrite_TimeStamp TestWritesID Message
#> 1 2015-06-26 12:32:03            4  Hello!
#> 2 2015-06-26 13:05:17            5  Hello!
```
