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
#>  [4] "FruitStroop"       "LENA_Admin"        "LENA_Hours"       
#>  [7] "Literacy"          "MinPair_Admin"     "MinPair_Responses"
#> [10] "PPVT"              "SES"               "Scores_TimePoint1"
#> [13] "Study"             "StudyTask"         "VerbalFluency"

# use tbl to create a link to a tbl in the database
studies <- tbl(src = l2t, "Study") 
head(studies)
#>   StudyID      Study Code     Study_Timestamp
#> 1       1 TimePoint1    L 2015-06-26 14:44:06
#> 2       2 TimePoint2    L 2015-06-26 14:44:06
#> 3       3 TimePoint3    L 2015-06-26 14:44:06

# or use %from% as an infix form of the above
studies <- "Study" %from% l2t
head(studies)
#>   StudyID      Study Code     Study_Timestamp
#> 1       1 TimePoint1    L 2015-06-26 14:44:06
#> 2       2 TimePoint2    L 2015-06-26 14:44:06
#> 3       3 TimePoint3    L 2015-06-26 14:44:06
```

We can download and backup each table in the database with `l2t_backup`.

``` r
# backup each tbl
backup_dir <- "inst/backup"
all_tbls <- l2t_backup(l2t, backup_dir)
#> Writing inst/backup/2015_07_09/Child.csv
#> Writing inst/backup/2015_07_09/ChildStudy.csv
#> Writing inst/backup/2015_07_09/EVT.csv
#> Writing inst/backup/2015_07_09/FruitStroop.csv
#> Writing inst/backup/2015_07_09/LENA_Admin.csv
#> Writing inst/backup/2015_07_09/LENA_Hours.csv
#> Writing inst/backup/2015_07_09/Literacy.csv
#> Writing inst/backup/2015_07_09/MinPair_Admin.csv
#> Writing inst/backup/2015_07_09/MinPair_Responses.csv
#> Writing inst/backup/2015_07_09/PPVT.csv
#> Writing inst/backup/2015_07_09/SES.csv
#> Writing inst/backup/2015_07_09/Scores_TimePoint1.csv
#> Writing inst/backup/2015_07_09/Study.csv
#> Writing inst/backup/2015_07_09/StudyTask.csv
#> Writing inst/backup/2015_07_09/VerbalFluency.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
rows <- lapply(all_tbls, nrow)
data_frame(tbl = names(rows), rows = unlist(rows))
#> Source: local data frame [15 x 2]
#> 
#>                  tbl rows
#> 1              Child  224
#> 2         ChildStudy  224
#> 3                EVT  224
#> 4        FruitStroop    0
#> 5         LENA_Admin  182
#> 6         LENA_Hours 2968
#> 7           Literacy    0
#> 8      MinPair_Admin  190
#> 9  MinPair_Responses 7508
#> 10              PPVT  224
#> 11               SES    0
#> 12 Scores_TimePoint1    0
#> 13             Study    3
#> 14         StudyTask   12
#> 15     VerbalFluency    0

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
#> Variables not shown: ChildStudy_Timestamp (chr), Exclude (int),
#>   ExcludeNotes (chr)
```

As I've worked on the back-end of the database, I've been using the Comment fields to describe the data that goes into each field. We can download these comments along with other pieces of information about a table by using `describe_tbl`. With this function, we can quickly create a "codebook" to accompany our data.

``` r
describe_tbl(l2t, "EVT")
#>    Table          Field Index      DataType      DefaultValue NullAllowed
#> 1    EVT   ChildStudyID   UNI       int(11)              <NA>          NO
#> 2    EVT          EVTID   PRI       int(11)              <NA>          NO
#> 3    EVT  EVT_Timestamp            datetime CURRENT_TIMESTAMP          NO
#> 4    EVT       EVT_Form       enum('A','B')              <NA>         YES
#> 5    EVT EVT_Completion                date              <NA>         YES
#> 6    EVT        EVT_Raw             int(11)              <NA>         YES
#> 7    EVT   EVT_Standard             int(11)              <NA>         YES
#> 8    EVT        EVT_GSV             int(11)              <NA>         YES
#> 9    EVT        EVT_Age              int(3)              <NA>         YES
#> 10   EVT       EVT_Note        varchar(255)              <NA>         YES
#>                                                Description
#> 1                                                         
#> 2                                                         
#> 3                    When the record (row) was last edited
#> 4                                     Form of the EVT test
#> 5                                   Date EVT was completed
#> 6                              Raw score (number of words)
#> 7                                           Standard score
#> 8                                       Growth scale value
#> 9  Age in months (rounded down) when the EVT was completed
#> 10                            Notes on test administration
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
#> 1            5  Hello!  2015-07-09 11:32:12
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
