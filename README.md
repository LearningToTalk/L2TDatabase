
<!-- README.md is generated from README.Rmd. Please edit that file -->
L2TDatabase
===========

This R package contains helper functions for working with the MySQL database for the [Learning To Talk](http://learningtotalk.org) project.

Connect with .cnf files
-----------------------

Connections to the database are managed by [.cnf files](http://svitsrv25.epfl.ch/R-doc/library/RMySQL/html/RMySQL-package.html). We use these files so that login credentials and connection information are not hard-coded into analysis scripts. This package provides `make_cnf_file` which creates a cnf file from login and connection information.

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

Once we've created a .cnf file, we can connect to the database using `l2t_connect`. We can view the names of all the tables in the database with `dplyr::src_tbls`. See the dplyr [vignette on databases](http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html) for how to work with remotely stored data using dplyr; it's really great stuff.

``` r
library("dplyr", warn.conflicts = FALSE)

# connect to the database
l2t <- l2t_connect(cnf_file = cnf_file, db_name = "l2t")

# list all the tbls in the database
src_tbls(l2t)
#>  [1] "BRIEF"             "Caregivers"        "Caregivers_Entry" 
#>  [4] "Child"             "ChildStudy"        "EVT"              
#>  [7] "FruitStroop"       "LENA_Admin"        "LENA_Hours"       
#> [10] "Literacy"          "MinPair_Admin"     "MinPair_Responses"
#> [13] "PPVT"              "SES"               "SES_Entry"        
#> [16] "Scores_TimePoint1" "Siblings"          "Study"            
#> [19] "StudyTask"         "VerbalFluency"

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

Back up
-------

We can download and backup each table in the database with `l2t_backup`.

``` r
# backup each tbl
backup_dir <- "inst/backup"
all_tbls <- l2t_backup(src = l2t, backup_dir = backup_dir)
#> Writing inst/backup/2016-03-08_11-59/BRIEF.csv
#> Writing inst/backup/2016-03-08_11-59/Caregivers.csv
#> Writing inst/backup/2016-03-08_11-59/Caregivers_Entry.csv
#> Writing inst/backup/2016-03-08_11-59/Child.csv
#> Writing inst/backup/2016-03-08_11-59/ChildStudy.csv
#> Writing inst/backup/2016-03-08_11-59/EVT.csv
#> Writing inst/backup/2016-03-08_11-59/FruitStroop.csv
#> Writing inst/backup/2016-03-08_11-59/LENA_Admin.csv
#> Writing inst/backup/2016-03-08_11-59/LENA_Hours.csv
#> Writing inst/backup/2016-03-08_11-59/Literacy.csv
#> Writing inst/backup/2016-03-08_11-59/MinPair_Admin.csv
#> Writing inst/backup/2016-03-08_11-59/MinPair_Responses.csv
#> Writing inst/backup/2016-03-08_11-59/PPVT.csv
#> Writing inst/backup/2016-03-08_11-59/SES.csv
#> Writing inst/backup/2016-03-08_11-59/SES_Entry.csv
#> Writing inst/backup/2016-03-08_11-59/Scores_TimePoint1.csv
#> Writing inst/backup/2016-03-08_11-59/Siblings.csv
#> Writing inst/backup/2016-03-08_11-59/Study.csv
#> Writing inst/backup/2016-03-08_11-59/StudyTask.csv
#> Writing inst/backup/2016-03-08_11-59/VerbalFluency.csv
#> Writing inst/backup/2016-03-08_11-59/metadata/field_descriptions.csv
#> Writing inst/backup/2016-03-08_11-59/metadata/table_descriptions.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
rows <- lapply(all_tbls, nrow)
data_frame(tbl = names(rows), rows = unlist(rows))
#> Source: local data frame [20 x 2]
#> 
#>                  tbl  rows
#>                (chr) (int)
#> 1              BRIEF   224
#> 2         Caregivers     0
#> 3   Caregivers_Entry   477
#> 4              Child   224
#> 5         ChildStudy   559
#> 6                EVT   559
#> 7        FruitStroop     0
#> 8         LENA_Admin   182
#> 9         LENA_Hours  2968
#> 10          Literacy   207
#> 11     MinPair_Admin   190
#> 12 MinPair_Responses  7508
#> 13              PPVT   406
#> 14               SES   224
#> 15         SES_Entry   216
#> 16 Scores_TimePoint1     0
#> 17          Siblings     0
#> 18             Study     3
#> 19         StudyTask    12
#> 20     VerbalFluency     0

all_tbls$ChildStudy
#> Source: local data frame [559 x 8]
#> 
#>    ChildStudyID ChildID StudyID ShortResearchID FullResearchID
#>           (int)   (int)   (int)           (chr)          (chr)
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

Metadata
--------

As I've worked on the back-end of the database, I've been using the Comment fields to describe the data that goes into each field. We can download these comments along with other pieces of information about a table by using `describe_tbl`. With this function, we can quickly create a "codebook" to accompany our data. I have [blogged about](http://tjmahr.com/post/127080928329/using-dplyr-to-back-up-a-mysql-database) the implementation of these metadata-related functions.

``` r
describe_tbl(src = l2t, tbl_name = "EVT")
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
#> 1  Child-Study ID (uniquely defines a Child-Study pairing)
#> 2                                    EVT Administration ID
#> 3                   When each record (row) was last edited
#> 4            EVT test form used. A, B or NULL (if unknown)
#> 5                                   Date EVT was completed
#> 6                              Raw score (number of words)
#> 7                                           Standard score
#> 8                                       Growth scale value
#> 9      Age in months (rounded down) when EVT was completed
#> 10                            Notes on test administration
```

We can also download the table-level comments from a database with `describe_db`, although these descriptions have a much tighter length limit.

``` r
describe_db(src = l2t)
#>    Database             Table Rows
#> 1       l2t             BRIEF  224
#> 2       l2t        Caregivers    0
#> 3       l2t  Caregivers_Entry  444
#> 4       l2t             Child  224
#> 5       l2t        ChildStudy  559
#> 6       l2t               EVT  559
#> 7       l2t       FruitStroop    0
#> 8       l2t        LENA_Admin  182
#> 9       l2t        LENA_Hours 2968
#> 10      l2t          Literacy  207
#> 11      l2t     MinPair_Admin  190
#> 12      l2t MinPair_Responses 7674
#> 13      l2t              PPVT  406
#> 14      l2t               SES  224
#> 15      l2t         SES_Entry  215
#> 16      l2t Scores_TimePoint1    0
#> 17      l2t          Siblings    0
#> 18      l2t             Study    3
#> 19      l2t         StudyTask   12
#> 20      l2t     VerbalFluency    0
#>                                                    Description
#> 1  Scores from Behvr Rating Inventory of Exec Func (Preschool)
#> 2                        Demographics of children's caregivers
#> 3      Demographics of children's caregivers (temp data-entry)
#> 4          Unique IDs and demographics of children in database
#> 5                                                             
#> 6                       Scores on Expressive Vocabulary Test 2
#> 7                                                             
#> 8                                              LENA recordings
#> 9                    Stats from LENA recordings by hour-of-day
#> 10                                                            
#> 11             Administrations of the Minimal Pairs experiment
#> 12      Trials and responses from the Minimal Pairs experiment
#> 13                 Scores on Peabody Picture Vocabulary Test 4
#> 14                            Child and household demographics
#> 15          Child and household demographics (temp data-entry)
#> 16                                                            
#> 17                              Sibling and Twin Relationships
#> 18                                                            
#> 19                                                            
#> 20
```

These two forms of metadata are backed up by `l2t_backup` as well. They are stored in a `metadata` folder.

Dumping the database
--------------------

A final option for backing up the database is `dump_database`. This function calls on the `mysqldump` utility which exports a database into a series of SQL statements that can be used to reconstruct the database.

``` r
dump_database(
  cnf_file = cnf_file, 
  backup_dir = "inst/backup",
  db_name = "l2t")
#> Checking inst/backup/l2t_2016-03-08_11-59.sql
#> ..file size: 1193.369 kB
#> ..line count: 699
#> ..first line: -- MySQL dump 10.13  Distrib 5.6.26, for Win64 (x86_64)
#> ..final line: -- Dump completed on 2016-03-08 11:59:55
```

Writing
-------

dplyr provides read-only access to a database, so we can't accidentally do stupid things to our data. We want to use R to migrate existing dataframes into the database, but we also don't want to do stupid things either. Therefore, I've developed very conservative helper functions for writing data. In fact there is only such function so far: `append_rows_to_table`. (I'd like to add an `overwrite_rows_in_table` eventually.) These functions work on dplyr-managed database connections. For the purposes of this demo, we will work on the separate `l2t_test` database.

``` r
l2t_test <- l2t_connect(cnf_file, db_name = "l2ttest")

# Add rows to table
append_rows_to_table(
  src = l2t_test, 
  tbl_name = "TestWrites", 
  rows = data_frame(Message = "Hello!"))
#> [1] TRUE

# After writing
tbl(l2t_test, "TestWrites")
#> Source: mysql 5.6.20 [mahr_data@l2t-db.cla.umn.edu:/l2ttest]
#> From: TestWrites [1 x 3]
#> 
#>   TestWritesID Message TestWrites_TimeStamp
#>          (int)   (chr)                (chr)
#> 1            4  Hello!  2016-03-08 11:59:55
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
