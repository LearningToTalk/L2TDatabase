
<!-- README.md is generated from README.Rmd. Please edit that file -->
L2TDatabase
===========

This R package contains helper functions for working with the MySQL database for the [Learning To Talk](http://learningtotalk.org) project.

Installation
------------

Install the `devtools` package. Then install the package from GitHub.

``` r
install.packages("devtools")
devtools::install_github("LearningToTalk/L2TDatabase")
```

Connecting with .cnf files
--------------------------

Connections to the database are managed by [.cnf files](http://svitsrv25.epfl.ch/R-doc/library/RMySQL/html/RMySQL-package.html). We use these files so that login credentials and connection information are not hard-coded into analysis scripts.

This package provides the helper function `make_cnf_file` which creates a .cnf file from login and connection information. Once the file is created, we can just point to this file whenever we want to connect to the database.

``` r
library("L2TDatabase")

# initialze a cnf file using all default (empty) values
make_cnf_file(dest = "./my_connection.cnf")
#> Writing to ./my_connection.cnf:
#> [client]
#> user=
#> password=
#> host=
#> port=3306
#> 
#> [rs-dbi]
#> database=

# all values filled
make_cnf_file(
  dest = "./my_connection.cnf", 
  user = "tj", 
  password = "dummy-password", 
  db = "my_db", 
  host = "localhost", 
  port = 3306)
#> Writing to ./my_connection.cnf:
#> [client]
#> user=tj
#> password=dummy-password
#> host=localhost
#> port=3306
#> 
#> [rs-dbi]
#> database=my_db
```

We use the function `l2t_connect` to connect to the database. This function takes the location of a .cnf file and the name of the database and returns a connection to the database. By default, `l2t_connect` connects to the `l2t` database.

``` r
# connect to the database
l2t <- l2t_connect(cnf_file = "./inst/l2t_db.cnf", db_name = "l2t")
```

Using dplyr to look at the database
-----------------------------------

This package is built on top of [dplyr](https://cran.rstudio.com/web/packages/dplyr/), a package for dealing with data stored in tables. dplyr provides a set of tools for working with remote data sources --- that is data in databases, usually on other computers. Conventionally, to access data in a database, one has to write special queries to retrieve information from the database. dplyr lets us write R code for our queries, and it translates our R code into the language used by the database. (See the dplyr [vignette on databases](http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html) for more information on how to work with remotely stored data using dplyr.)

In language of dplyr, a remote *source* of data is a `src`, and a *table* of data is a `tbl`. To connect to a table of data, use `tbl(src, tbl_name)`. For example, here's how I would connect to the `MinPair_Responses` table in the database which contains the trial-level data about minimal pairs experiment.

``` r
library("dplyr", warn.conflicts = FALSE)

# use tbl to create a link to a tbl in the database
minp_resp <- tbl(src = l2t, from = "MinPair_Responses") 
minp_resp
#> Source:   query [?? x 10]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>    ResponseID MinPairID         Running Trial Item1 Item2 ImageSide
#>         <int>     <int>           <chr> <int> <chr> <chr>     <chr>
#> 1           1       127 Familiarization     1   man  moon      Left
#> 2           2       127 Familiarization     2 store story     Right
#> 3           3       127 Familiarization     3  same  game      Left
#> 4           4       127 Familiarization     4 store story      Left
#> 5           5       127 Familiarization     5  same  game     Right
#> 6           6       127 Familiarization     6   man  moon     Right
#> 7           7       127            Test     1 goose juice     Right
#> 8           8       127            Test     2 moose goose     Right
#> 9           9       127            Test     3   pig   big     Right
#> 10         10       127            Test     4 mouse moose     Right
#> # ... with more rows, and 3 more variables: CorrectResponse <chr>,
#> #   Correct <int>, MinPair_Responses_Timestamp <chr>
```

With dplyr, I can perform all kinds of operations on this table. Here, I specify a subset of columns to keep with `select` and `filter` to keep just the *man*- *moon* practice trials.

``` r
man_moon_practice <- minp_resp %>% 
  select(MinPairID:Correct) %>% 
  filter(Item1 == "man", Item2 == "moon")
man_moon_practice
#> Source:   query [?? x 8]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>    MinPairID         Running Trial Item1 Item2 ImageSide CorrectResponse
#>        <int>           <chr> <int> <chr> <chr>     <chr>           <chr>
#> 1        304 Familiarization     5   man  moon      Left             man
#> 2        425 Familiarization     3   man  moon     Right            moon
#> 3        207 Familiarization     6   man  moon     Right            moon
#> 4        407 Familiarization     5   man  moon      Left             man
#> 5        208 Familiarization     6   man  moon     Right            moon
#> 6        306 Familiarization     5   man  moon      Left             man
#> 7        427 Familiarization     3   man  moon     Right            moon
#> 8        209 Familiarization     6   man  moon     Right            moon
#> 9        409 Familiarization     5   man  moon      Left             man
#> 10       147 Familiarization     1   man  moon      Left             man
#> # ... with more rows, and 1 more variables: Correct <int>
```

This data lives in "the cloud" on a remote computer. That's why the first line of the print out says `Source: query [?? x 8]`. When we print the data as we did above, dplyr downloads just enough rows of data to give us a preview of the data. There are approximately 12,000 rows of data in the `minp_resp` table, and this just-a-preview behavior prevented us from accidentally or prematurely downloading thousands of rows when we peeked at the data. We have to **use `collect` to download data to our computer**.

``` r
man_moon_practice <- collect(man_moon_practice)
man_moon_practice
#> # A tibble: 640 × 8
#>    MinPairID         Running Trial Item1 Item2 ImageSide CorrectResponse
#>        <int>           <chr> <int> <chr> <chr>     <chr>           <chr>
#> 1        183 Familiarization     6   man  moon      Left             man
#> 2        278 Familiarization     3   man  moon     Right            moon
#> 3        260 Familiarization     3   man  moon     Right            moon
#> 4        185 Familiarization     6   man  moon      Left             man
#> 5        280 Familiarization     3   man  moon     Right            moon
#> 6        262 Familiarization     3   man  moon     Right            moon
#> 7        187 Familiarization     6   man  moon      Left             man
#> 8        282 Familiarization     3   man  moon     Right            moon
#> 9        264 Familiarization     3   man  moon     Right            moon
#> 10       284 Familiarization     3   man  moon     Right            moon
#> # ... with 630 more rows, and 1 more variables: Correct <int>
```

In this printout, there is no longer a line specifying the source. Instead, we are told that we have a `tibble`, which is just a kind of data-frame. The data now live locally, in our R session. Now, we can plot or model this data like any other data-frame in R.

**Take-away**: We use dplyr to create queries for data from tables in a database, and we use `collect` download the results of the query to our computer.

L2T Database conventions
------------------------

There are two kinds of tables, basically, in the `l2t` database: raw data and queries. The raw data tables do not contain any of our participant IDs or study names. The query tables provide useful summaries of the raw data and include our conventional participant IDs.

Query tables start with the prefix `q_`. We can view the names of all the tables in the database with `dplyr::src_tbls`.

``` r
# list all the tbls in the database
src_tbls(l2t)
#>  [1] "BRIEF"                      "Blending_Admin"            
#>  [3] "Blending_Responses"         "Caregivers"                
#>  [5] "Caregivers_Entry"           "Child"                     
#>  [7] "ChildStudy"                 "EVT"                       
#>  [9] "FruitStroop"                "GFTA"                      
#> [11] "LENA_Admin"                 "LENA_Hours"                
#> [13] "Literacy"                   "MinPair_Admin"             
#> [15] "MinPair_Responses"          "PPVT"                      
#> [17] "SAILS_Admin"                "SAILS_Responses"           
#> [19] "SES"                        "SES_Entry"                 
#> [21] "Siblings"                   "Study"                     
#> [23] "VerbalFluency"              "q_LENA_Averages"           
#> [25] "q_MinPair_Aggregate"        "q_SAILS_Aggregate"         
#> [27] "q_SAILS_ModulesPropCorrect" "q_SAILS_PropCorrect"       
#> [29] "q_Scores_TimePoint1"        "q_Scores_TimePoint2"       
#> [31] "q_Scores_TimePoint3"
```

The `q_MinPair_Aggregate` shows the proportion correct of non-practice trials in the minimal pairs task by participant and by study. (I `select` a subset of columns to exclude unnecessary columns like the name of the Eprime file containing the raw data.) The `Study` and `ResearchID` are the conventional identifiers for studies and participants.

``` r
tbl(l2t, "q_MinPair_Aggregate") %>% 
  select(Study, ResearchID, MinPair_Dialect, MinPair_ProportionCorrect)
#> Source:   query [?? x 4]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>         Study ResearchID MinPair_Dialect MinPair_ProportionCorrect
#>         <chr>      <chr>           <chr>                     <dbl>
#> 1  TimePoint1       600L             SAE                      0.94
#> 2  TimePoint1       601L             SAE                      0.82
#> 3  TimePoint1       602L             SAE                      0.52
#> 4  TimePoint1       603L             SAE                      0.98
#> 5  TimePoint1       604L             SAE                      0.96
#> 6  TimePoint1       605L             SAE                      0.54
#> 7  TimePoint1       606L             SAE                      0.56
#> 8  TimePoint1       607L             SAE                      0.90
#> 9  TimePoint1       608L             SAE                      0.94
#> 10 TimePoint1       609L             SAE                      0.44
#> # ... with more rows
```

Take-away: The data you probably want lives in a table that starts with `q_`.

Metadata
--------

As I've worked on the back-end of the database, I've been using the database comments to describe the data that goes into each table and each field. We can download these comments along with other pieces of information about a table by using `describe_tbl`. With this function, we can quickly create a "codebook" to accompany our data.

``` r
describe_tbl(src = l2t, tbl_name = "q_MinPair_Aggregate")
#>                 Table                     Field Index          DataType
#> 1 q_MinPair_Aggregate              ChildStudyID                 int(11)
#> 2 q_MinPair_Aggregate                     Study            varchar(255)
#> 3 q_MinPair_Aggregate                ResearchID              varchar(4)
#> 4 q_MinPair_Aggregate                 MinPairID                 int(11)
#> 5 q_MinPair_Aggregate        MinPair_EprimeFile             varchar(16)
#> 6 q_MinPair_Aggregate        MinPair_Completion                    date
#> 7 q_MinPair_Aggregate           MinPair_Dialect       enum('SAE','AAE')
#> 8 q_MinPair_Aggregate               MinPair_Age                  int(4)
#> 9 q_MinPair_Aggregate MinPair_ProportionCorrect            decimal(7,4)
#>   DefaultValue NullAllowed
#> 1            0          NO
#> 2         <NA>         YES
#> 3         <NA>         YES
#> 4            0         YES
#> 5         <NA>         YES
#> 6         <NA>         YES
#> 7         <NA>         YES
#> 8         <NA>         YES
#> 9         <NA>         YES
#>                                                                                         Description
#> 1                                           Child-Study ID (uniquely defines a Child-Study pairing)
#> 2                                                                                 Name of the study
#> 3                                              Four character form of the participant's Research ID
#> 4                                                        Minimal Pairs Experiment Administration ID
#> 5     Filename of Eprime output for this administration (minus .txt extension). Source of the data.
#> 6 Date the MinPairs experiment was administered. Extracted from XML blob in Eprime txt output file.
#> 7                                      Dialect version of the experiment (based on Eprime filename)
#> 8                                     Age in months (rounded down) when Minimal Pairs was completed
#> 9
```

In some queries, the fields are computed dynamically, whenever the data is requested. For example, in the `q_MinPair_Aggregate` query, the proportion correct is calculated on-the-fly. Our database system does not let us write comments for these dynamically created columns, so that column has a blank for its description.

We can also download the table-level comments from a database with `describe_db`, although these descriptions have a much tighter length limit. Table-level comments are also unavailable for the query table.

``` r
# just a few rows
describe_db(src = l2t) %>% head()
#>   Database              Table Rows
#> 1      l2t              BRIEF  224
#> 2      l2t     Blending_Admin    0
#> 3      l2t Blending_Responses    0
#> 4      l2t         Caregivers    0
#> 5      l2t   Caregivers_Entry  526
#> 6      l2t              Child  247
#>                                                   Description
#> 1 Scores from Behvr Rating Inventory of Exec Func (Preschool)
#> 2                  Administrations of the Blending experiment
#> 3           Trials and responses from the Blending experiment
#> 4                [Todo] Demographics of children's caregivers
#> 5     [Temp Data Entry] Demographics of children's caregivers
#> 6         Unique IDs and demographics of children in database
```

These two forms of metadata are backed up by the `l2t_backup` helper.

Back up
-------

We can download and back up each table in the database with `l2t_backup`. The final two messages from the back-up function show that the metadata tables are saved to a `metadata` folder.

``` r
# back up each tbl
backup_dir <- "./inst/backup"
all_tbls <- l2t_backup(src = l2t, backup_dir = backup_dir)
#> Writing ./inst/backup/2016-09-13_10-45/BRIEF.csv
#> Writing ./inst/backup/2016-09-13_10-45/Blending_Admin.csv
#> Writing ./inst/backup/2016-09-13_10-45/Blending_Responses.csv
#> Writing ./inst/backup/2016-09-13_10-45/Caregivers.csv
#> Writing ./inst/backup/2016-09-13_10-45/Caregivers_Entry.csv
#> Writing ./inst/backup/2016-09-13_10-45/Child.csv
#> Writing ./inst/backup/2016-09-13_10-45/ChildStudy.csv
#> Writing ./inst/backup/2016-09-13_10-45/EVT.csv
#> Writing ./inst/backup/2016-09-13_10-45/FruitStroop.csv
#> Writing ./inst/backup/2016-09-13_10-45/GFTA.csv
#> Writing ./inst/backup/2016-09-13_10-45/LENA_Admin.csv
#> Writing ./inst/backup/2016-09-13_10-45/LENA_Hours.csv
#> Writing ./inst/backup/2016-09-13_10-45/Literacy.csv
#> Writing ./inst/backup/2016-09-13_10-45/MinPair_Admin.csv
#> Writing ./inst/backup/2016-09-13_10-45/MinPair_Responses.csv
#> Writing ./inst/backup/2016-09-13_10-45/PPVT.csv
#> Writing ./inst/backup/2016-09-13_10-45/SAILS_Admin.csv
#> Writing ./inst/backup/2016-09-13_10-45/SAILS_Responses.csv
#> Writing ./inst/backup/2016-09-13_10-45/SES.csv
#> Writing ./inst/backup/2016-09-13_10-45/SES_Entry.csv
#> Writing ./inst/backup/2016-09-13_10-45/Siblings.csv
#> Writing ./inst/backup/2016-09-13_10-45/Study.csv
#> Writing ./inst/backup/2016-09-13_10-45/VerbalFluency.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_LENA_Averages.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_MinPair_Aggregate.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_SAILS_Aggregate.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_SAILS_ModulesPropCorrect.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_SAILS_PropCorrect.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_Scores_TimePoint1.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_Scores_TimePoint2.csv
#> Writing ./inst/backup/2016-09-13_10-45/q_Scores_TimePoint3.csv
#> Writing ./inst/backup/2016-09-13_10-45/metadata/field_descriptions.csv
#> Writing ./inst/backup/2016-09-13_10-45/metadata/table_descriptions.csv

# l2t_backup also returns each tbl in a list, so we can view them as well.
all_tbls$ChildStudy
#> # A tibble: 604 × 8
#>    ChildStudyID ChildID StudyID ShortResearchID FullResearchID
#>           <int>   <int>   <int>           <chr>          <chr>
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
#> # ... with 594 more rows, and 3 more variables:
#> #   ChildStudy_Timestamp <chr>, ChildStudy_Exclude <int>,
#> #   ChildStudy_ExcludeNote <chr>
```

### Dumping the database

A final option for backing up the database is `dump_database`. This function calls on the `mysqldump` utility which exports a database into a series of SQL statements that can be used to reconstruct the database. This function is more finicky because it requires other programs to be installed on one's machine.

``` r
dump_database(
  cnf_file = cnf_file, 
  backup_dir = "./inst/backup",
  db_name = "l2t")
```

Writing
-------

dplyr provides read-only access to a database, so we can't accidentally do stupid things to our data. We want to use R to migrate existing dataframes into the database, but we also don't want to do stupid things either. Therefore, I've developed conservative helper functions for writing data. In fact there is only one such function so far: `append_rows_to_table`. (I'd like to add an `overwrite_rows_in_table` eventually.) These functions work on dplyr-managed database connections. For the purposes of this demo, we will work on the separate `l2t_test` database.

``` r
l2t_test <- l2t_connect("./inst/l2t_db.cnf", db_name = "l2ttest")

# Before writing
tbl(l2t_test, "TestWrites")
#> Source:   query [?? x 3]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2ttest]
#> 
#> # ... with 3 variables: TestWritesID <int>, Message <chr>,
#> #   TestWrites_TimeStamp <chr>

# Add rows to table
append_rows_to_table(
  src = l2t_test, 
  tbl_name = "TestWrites", 
  rows = data_frame(Message = "Hello!"))
#> [1] TRUE

# After writing
tbl(l2t_test, "TestWrites")
#> Source:   query [?? x 3]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2ttest]
#> 
#>   TestWritesID Message TestWrites_TimeStamp
#>          <int>   <chr>                <chr>
#> 1           15  Hello!  2016-09-13 10:45:15
```

Other helpers
-------------

This package also provides some helper functions for working with our data. `undo_excel_date` converts Excel's dates into R dates. `chrono_age` computes the number of months (rounded down) between two dates, as you would when computing chronological age.

``` r
# Create a date and another 18 months later
dates <- list()
dates$t1 <- undo_excel_date(41659)
dates$t2 <- undo_excel_date(41659 + 365 + 181)
str(dates)
#> List of 2
#>  $ t1: Date[1:1], format: "2014-01-20"
#>  $ t2: Date[1:1], format: "2015-07-20"

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
