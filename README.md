L2TDatabase
================

-   [Installation](#installation)
-   [Connecting with .cnf files](#connecting-with-.cnf-files)
-   [Using dplyr to look at the database](#using-dplyr-to-look-at-the-database)
-   [L2T Database conventions](#l2t-database-conventions)
-   [Metadata](#metadata)
-   [Back up](#back-up)
-   [Writing new data to a database](#writing-new-data-to-a-database)
-   [Other helpers](#other-helpers)
-   [Repository structure](#repository-structure)
-   [Data audits](#data-audits)
-   [Study coverage](#study-coverage)

<!-- README.md is generated from README.Rmd. Please edit that file -->
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

This package provides the helper function `make_cnf_file()` which creates a .cnf file from login and connection information. Once the file is created, we can just point to this file whenever we want to connect to the database.

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

We use the function `l2t_connect()` to connect to the database. This function takes the location of a .cnf file and the name of the database and returns a connection to the database. By default, `l2t_connect` connects to the `l2t` database.

``` r
# connect to the database
l2t <- l2t_connect(cnf_file = "./inst/l2t_db.cnf", db_name = "l2t")
```

Using dplyr to look at the database
-----------------------------------

This package is built on top of [dplyr](https://cran.rstudio.com/web/packages/dplyr/), a package for dealing with data stored in tables. dplyr provides a set of tools for working with remote data sources --- that is, data in databases, usually on other computers. Conventionally, to access data in a database, one has to write special queries to retrieve information from the database. dplyr lets us write R code for our queries, and it translates our R code into the language used by the database. (See the dplyr [vignette on databases](http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html) for more information on how to work with remotely stored data using dplyr.)

In the terminology of dplyr, a remote *source* of data is a `src`, and a *table* of data is a `tbl`. To connect to a table of data, use `tbl(src, tbl_name)`. For example, here's how I would connect to the `MinPair_Trials` table in the database which contains the trial-level data about the minimal pairs experiment.

``` r
library("dplyr", warn.conflicts = FALSE)

# use tbl to create a link to a tbl in the database
minp_resp <- tbl(src = l2t, from = "MinPair_Trials") 
minp_resp
#> Source:   query [?? x 13]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>               Study ResearchID MinPair_EprimeFile MinPair_Dialect
#>               <chr>      <chr>              <chr>           <chr>
#> 1  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 2  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 3  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 4  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 5  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 6  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 7  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 8  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 9  CochlearMatching       390A     MINP_390A69FS3             SAE
#> 10 CochlearMatching       390A     MINP_390A69FS3             SAE
#> # ... with more rows, and 9 more variables: MinPair_Completion <chr>,
#> #   MinPair_Age <int>, MinPair_TrialType <chr>, MinPair_Trial <int>,
#> #   MinPair_Item1 <chr>, MinPair_Item2 <chr>, MinPair_ImageSide <chr>,
#> #   MinPair_TargetItem <chr>, MinPair_Correct <int>
```

With dplyr, I can perform all kinds of operations on this table. Here, I `filter()` rows to keep just the *man*-*moon* practice trials and `select()` a subset of columns.

``` r
man_moon_practice <- minp_resp %>% 
  filter(MinPair_Item1 == "man", MinPair_Item2 == "moon") %>% 
  select(Study, ResearchID, MinPair_TargetItem, MinPair_Correct)
man_moon_practice
#> Source:   query [?? x 4]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>               Study ResearchID MinPair_TargetItem MinPair_Correct
#>               <chr>      <chr>              <chr>           <int>
#> 1  CochlearMatching       390A               moon               1
#> 2  CochlearMatching       390A                man               1
#> 3  CochlearMatching       391A               moon               1
#> 4  CochlearMatching       391A                man               1
#> 5  CochlearMatching       393A               moon               1
#> 6  CochlearMatching       393A                man               1
#> 7        CochlearV1       300E               moon               1
#> 8        CochlearV1       300E                man               1
#> 9        CochlearV1       301E               moon               0
#> 10       CochlearV1       301E                man               1
#> # ... with more rows
```

This data lives in "the cloud" on a remote computer. That's why the first line of the print out says `Source: query [?? x 4]`. When we print the data as we did above, dplyr downloads just enough rows of data to give us a preview of the data. There are approximately 12,000 rows of data in the `minp_resp` table, and this just-a-preview behavior prevented us from accidentally or prematurely downloading thousands of rows when we peeked at the data. We have to **use `collect()` to download data to our computer**.

``` r
man_moon_practice <- collect(man_moon_practice)
man_moon_practice
#> # A tibble: 884 × 4
#>               Study ResearchID MinPair_TargetItem MinPair_Correct
#>               <chr>      <chr>              <chr>           <int>
#> 1  CochlearMatching       390A               moon               1
#> 2  CochlearMatching       390A                man               1
#> 3  CochlearMatching       391A               moon               1
#> 4  CochlearMatching       391A                man               1
#> 5  CochlearMatching       393A               moon               1
#> 6  CochlearMatching       393A                man               1
#> 7        CochlearV1       300E               moon               1
#> 8        CochlearV1       300E                man               1
#> 9        CochlearV1       301E               moon               0
#> 10       CochlearV1       301E                man               1
#> # ... with 874 more rows
```

In this printout, there is no longer a line specifying the source. Instead, we are told that we have a `tibble`, which is just a kind of data-frame. The data now lives locally, in our R session. Now, we can plot or model this data like any other data-frame in R.

**Take-away**: We use dplyr to create queries for data from tables in a database, and we use `collect()` download the results of the query to our computer.

L2T Database conventions
------------------------

### User-ready data lives in the default database `l2t`

Information about our participants and their testing data are stored in two separate databases. The first is `l2t`. This database contains user-friendly, analysis-ready tables of information. `l2t` is the default database that `l2t_connect()` uses. This database probably has the information that you need in a ready to use form.

``` r
# list all the tbls in the database
src_tbls(l2t)
#>  [1] "BRIEF"                     "Blending_Summary"         
#>  [3] "CTOPP_Blending"            "CTOPP_Elision"            
#>  [5] "CTOPP_Memory"              "EVT"                      
#>  [7] "FruitStroop"               "GFTA"                     
#>  [9] "LENA_Averages"             "Maternal_Education_Levels"
#> [11] "MinPair_Aggregate"         "MinPair_Trials"           
#> [13] "PPVT"                      "Rhyming_Aggregate"        
#> [15] "SAILS_Aggregate"           "SAILS_Module_Aggregate"   
#> [17] "Scores_CochlearV1"         "Scores_CochlearV2"        
#> [19] "Scores_TimePoint1"         "Scores_TimePoint2"        
#> [21] "Scores_TimePoint3"         "VerbalFluency"
```

The tables here are *queries*: Tables that are computed on-the-fly whenever the data is requested. For example, `MinPair_Aggregate` shows the proportion correct of non-practice trials in the minimal pairs task by participant and by study. (I `select()` a subset of columns to exclude unnecessary columns like the name of the Eprime file containing the raw data.) The `Study` and `ResearchID` are the conventional identifiers for studies and participants.

``` r
tbl(l2t, "MinPair_Aggregate") %>% 
  select(Study, ResearchID, MinPair_Dialect, MinPair_ProportionCorrect)
#> Source:   query [?? x 4]
#> Database: mysql 5.6.20 [demo_user@dummy.host.name:/l2t]
#> 
#>               Study ResearchID MinPair_Dialect MinPair_ProportionCorrect
#>               <chr>      <chr>           <chr>                     <dbl>
#> 1  CochlearMatching       390A             SAE                    1.0000
#> 2  CochlearMatching       391A             SAE                    0.9667
#> 3  CochlearMatching       393A             SAE                    0.9667
#> 4        CochlearV1       300E             SAE                    0.6667
#> 5        CochlearV1       301E             SAE                    0.7667
#> 6        CochlearV1       302E             SAE                    0.6667
#> 7        CochlearV1       303E             SAE                    0.9000
#> 8        CochlearV1       304E             SAE                    0.3750
#> 9        CochlearV1       305E             SAE                    0.5000
#> 10       CochlearV1       306E             SAE                    0.6667
#> # ... with more rows
```

The values in `MinPair_ProportionCorrect` are not stored or hard-coded but computed on the fly as part of a query. Thus, if for some reason, the trial-level data about the experiment were to change in the database, then the `MinPair_ProportionCorrect` column would update automatically.

### Raw data lives in `backend`

The tables in `l2t` are queries, so they are assembled by combining information from tables of raw data. The raw-data tables live in the second database (the `backend` for our queries.) These raw data tables do not contain any of our participant IDs or study names, so they are not user-friendly. You probably don't need to work with the backend of the database, unless you are developing new aggregations of data that are not yet presented in the `l2t` database.

``` r
l2t_backend <- l2t_connect("./inst/l2t_db.cnf", db_name = "backend")
# list all the tbls in the database
src_tbls(l2t_backend)
#>  [1] "BRIEF"                             
#>  [2] "Blending_Admin"                    
#>  [3] "Blending_Responses"                
#>  [4] "CTOPP_Blending"                    
#>  [5] "CTOPP_Elision"                     
#>  [6] "CTOPP_Memory"                      
#>  [7] "Caregiver"                         
#>  [8] "Caregiver_Entry"                   
#>  [9] "Child"                             
#> [10] "ChildStudy"                        
#> [11] "EVT"                               
#> [12] "FruitStroop"                       
#> [13] "GFTA"                              
#> [14] "Household"                         
#> [15] "LENA_Admin"                        
#> [16] "LENA_Hours"                        
#> [17] "Literacy"                          
#> [18] "MinPair_Admin"                     
#> [19] "MinPair_Responses"                 
#> [20] "PPVT"                              
#> [21] "RealWordRep_Admin"                 
#> [22] "Rhyming_Admin"                     
#> [23] "Rhyming_Responses"                 
#> [24] "SAILS_Admin"                       
#> [25] "SAILS_Responses"                   
#> [26] "SES"                               
#> [27] "SES_Entry"                         
#> [28] "Study"                             
#> [29] "VerbalFluency"                     
#> [30] "q_Blending_ModulePropCorrect"      
#> [31] "q_Blending_PropCorrect"            
#> [32] "q_Blending_Summary"                
#> [33] "q_Blending_SupportPropCorrect"     
#> [34] "q_Household_Education"             
#> [35] "q_Household_Maternal_Caregiver"    
#> [36] "q_Household_Max_Maternal_Education"
#> [37] "q_LENA_Averages"                   
#> [38] "q_MinPair_Aggregate"               
#> [39] "q_Rhyming_Aggregate"               
#> [40] "q_Rhyming_PropCorrect"             
#> [41] "q_SAILS_Aggregate"                 
#> [42] "q_SAILS_PropCorrect"
```

Some of the tables in the backend are not tables of raw data but intermediate, helper queries that are used in the main database. These helpers queries are prefixed with `q_`. For example, `q_Household_Education`, `q_Household_Maternal_Caregiver`, and `q_Household_Max_Maternal_Education` are a pipeline of calculations that determine the highest maternal education level in each household.

### Other databases

Our eyetracking data lives in `eyetracking`. I separated it from the other kinds of data because it contains individual frames of eyetracking data, so it houses a tremendous amount of data. One of the tables has at least 10 millions rows of data. The database contains user-ready queries. They are prefixed by `q_`.

``` r
l2t_eyetracking <- l2t_connect("./inst/l2t_db.cnf", db_name = "eyetracking")
src_tbls(l2t_eyetracking)
#>  [1] "BlockAttributes"          "Blocks"                  
#>  [3] "Looks"                    "TrialAttributes"         
#>  [5] "Trials"                   "q_BlockAttributesByStudy"
#>  [7] "q_BlocksByStudy"          "q_LooksByStudy"          
#>  [9] "q_MissingDataByBlock"     "q_TrialAttributesByStudy"
#> [11] "q_TrialsByStudy"
```

There is also a database `norms` with some raw-score-to-standardized-score look-up tables for some standardized tests.

**Take-away**: The data you probably want lives in the default database `l2t`.

Metadata
--------

As I've worked on the back-end of the database, I've been using the database comments to describe the data that goes into each table and each field. We can download these comments along with other pieces of information about a table by using `describe_tbl()`. With this function, we can quickly create a "codebook" to accompany our data.

``` r
describe_tbl(src = l2t, tbl_name = "MinPair_Aggregate")
#>               Table                     Field Index          DataType
#> 1 MinPair_Aggregate                     Study            varchar(255)
#> 2 MinPair_Aggregate                ResearchID              varchar(4)
#> 3 MinPair_Aggregate        MinPair_EprimeFile             varchar(16)
#> 4 MinPair_Aggregate           MinPair_Dialect       enum('SAE','AAE')
#> 5 MinPair_Aggregate        MinPair_Completion                    date
#> 6 MinPair_Aggregate               MinPair_Age                  int(4)
#> 7 MinPair_Aggregate     MinPair_NumTestTrials              bigint(21)
#> 8 MinPair_Aggregate MinPair_ProportionCorrect            decimal(7,4)
#>   DefaultValue NullAllowed
#> 1         <NA>         YES
#> 2         <NA>         YES
#> 3         <NA>         YES
#> 4         <NA>         YES
#> 5         <NA>         YES
#> 6         <NA>         YES
#> 7            0          NO
#> 8         <NA>         YES
#>                                                                                         Description
#> 1                                                                                 Name of the study
#> 2                                              Four character form of the participant's Research ID
#> 3     Filename of Eprime output for this administration (minus .txt extension). Source of the data.
#> 4                                      Dialect version of the experiment (based on Eprime filename)
#> 5 Date the MinPairs experiment was administered. Extracted from XML blob in Eprime txt output file.
#> 6                                     Age in months (rounded down) when Minimal Pairs was completed
#> 7                                                                                                  
#> 8
```

In some queries, the fields are computed dynamically, whenever the data is requested. In the `MinPair_Aggregate` query, the proportion correct is calculated when the data is requested. Our database system does not let us write comments for these dynamically created columns, so that column has a blank for its description.

We can also download the table-level comments from a database with `describe_db()`, although these descriptions have a much tighter length limit. Table-level comments are also unavailable for query tables, so they are only useful for raw-data tables.

``` r
# just a few rows
describe_db(src = l2t_backend) %>% head()
#>   Database              Table Rows
#> 1  backend              BRIEF  314
#> 2  backend     Blending_Admin   65
#> 3  backend Blending_Responses 1643
#> 4  backend     CTOPP_Blending  245
#> 5  backend      CTOPP_Elision  245
#> 6  backend       CTOPP_Memory  175
#>                                                   Description
#> 1 Scores from Behvr Rating Inventory of Exec Func (Preschool)
#> 2                  Administrations of the Blending experiment
#> 3           Trials and responses from the Blending experiment
#> 4     Blending subtest of Comp Test of Phon Processing-2nd ed
#> 5      Elision subtest of Comp Test of Phon Processing-2nd ed
#> 6 MemForDigits subtest of Comp Test of Phon Processing-2nd ed
```

These two forms of metadata are backed up by the `l2t_backup()` helper function.

Back up
-------

We can download and back up each table in a database with `l2t_backup()`. The final two messages from the back-up function show that the metadata tables are saved to a `metadata` folder.

Here's how backing up the backend of the database looks:

``` r
# back up each tbl
backup_dir <- "./inst/backup"
all_tbls <- l2t_backup(src = l2t_backend, backup_dir = backup_dir)
#> Writing ./inst/backup/2017-01-18_15-57/BRIEF.csv
#> Writing ./inst/backup/2017-01-18_15-57/Blending_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/Blending_Responses.csv
#> Writing ./inst/backup/2017-01-18_15-57/CTOPP_Blending.csv
#> Writing ./inst/backup/2017-01-18_15-57/CTOPP_Elision.csv
#> Writing ./inst/backup/2017-01-18_15-57/CTOPP_Memory.csv
#> Writing ./inst/backup/2017-01-18_15-57/Caregiver.csv
#> Writing ./inst/backup/2017-01-18_15-57/Caregiver_Entry.csv
#> Writing ./inst/backup/2017-01-18_15-57/Child.csv
#> Writing ./inst/backup/2017-01-18_15-57/ChildStudy.csv
#> Writing ./inst/backup/2017-01-18_15-57/EVT.csv
#> Writing ./inst/backup/2017-01-18_15-57/FruitStroop.csv
#> Writing ./inst/backup/2017-01-18_15-57/GFTA.csv
#> Writing ./inst/backup/2017-01-18_15-57/Household.csv
#> Writing ./inst/backup/2017-01-18_15-57/LENA_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/LENA_Hours.csv
#> Writing ./inst/backup/2017-01-18_15-57/Literacy.csv
#> Writing ./inst/backup/2017-01-18_15-57/MinPair_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/MinPair_Responses.csv
#> Writing ./inst/backup/2017-01-18_15-57/PPVT.csv
#> Writing ./inst/backup/2017-01-18_15-57/RealWordRep_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/Rhyming_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/Rhyming_Responses.csv
#> Writing ./inst/backup/2017-01-18_15-57/SAILS_Admin.csv
#> Writing ./inst/backup/2017-01-18_15-57/SAILS_Responses.csv
#> Writing ./inst/backup/2017-01-18_15-57/SES.csv
#> Writing ./inst/backup/2017-01-18_15-57/SES_Entry.csv
#> Writing ./inst/backup/2017-01-18_15-57/Study.csv
#> Writing ./inst/backup/2017-01-18_15-57/VerbalFluency.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Blending_ModulePropCorrect.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Blending_PropCorrect.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Blending_Summary.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Blending_SupportPropCorrect.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Household_Education.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Household_Maternal_Caregiver.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Household_Max_Maternal_Education.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_LENA_Averages.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_MinPair_Aggregate.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Rhyming_Aggregate.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_Rhyming_PropCorrect.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_SAILS_Aggregate.csv
#> Writing ./inst/backup/2017-01-18_15-57/q_SAILS_PropCorrect.csv
#> Writing ./inst/backup/2017-01-18_15-57/metadata/field_descriptions.csv
#> Writing ./inst/backup/2017-01-18_15-57/metadata/table_descriptions.csv

# l2t_backup() also returns each tbl in a list, so we can view them as well.
all_tbls$EVT
#> # A tibble: 662 × 10
#>    ChildStudyID EVTID       EVT_Timestamp EVT_Form EVT_Completion EVT_Raw
#>           <int> <int>               <chr>    <chr>          <chr>   <int>
#> 1             1     1 2015-07-07 15:05:37        B     2012-10-29      69
#> 2             3     3 2016-07-01 15:22:10        B     2012-11-27      43
#> 3             4     4 2015-07-07 13:13:18        B     2012-12-07      70
#> 4             5     5 2015-07-07 13:13:18        A     2012-11-09      45
#> 5             6     6 2015-07-07 13:13:18        A     2012-11-12      13
#> 6             7     7 2016-01-20 13:56:28        A     2013-02-08      23
#> 7             8     8 2015-07-07 13:13:18        B     2012-11-13      41
#> 8             9     9 2015-07-07 13:13:18        A     2012-12-06      56
#> 9            10    10 2015-07-07 14:23:34        A     2012-12-10      10
#> 10           11    11 2015-07-07 13:13:18        A     2012-11-16      52
#> # ... with 652 more rows, and 4 more variables: EVT_Standard <int>,
#> #   EVT_GSV <int>, EVT_Age <int>, EVT_Note <chr>
```

### Dumping the database

A final option for backing up the database is `dump_database()`. This function calls on the `mysqldump` utility which exports a database into a series of SQL statements that can be used to reconstruct the database. This function is very finicky because it requires other programs to be installed on one's machine.

``` r
dump_database(
  cnf_file = "./inst/l2t_db.cnf", 
  backup_dir = "./inst/backup",
  db_name = "l2t")

dump_database(
  cnf_file = "./inst/l2t_db.cnf", 
  backup_dir = "./inst/backup",
  db_name = "backend")
```

Writing new data to a database
------------------------------

dplyr provides read-only access to a database, so we can't accidentally do stupid things to our data. We want to use R to migrate existing dataframes into the database, but we also don't want to do stupid things either. Therefore, I've developed conservative helper functions for writing data. These functions work on dplyr-managed database connections. For the purposes of this demo, we will work on the separate `l2t_test` database.

The function `append_rows_to_table()` simply adds new rows to a database table.

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
#> 1           26  Hello!  2017-01-18 15:57:52
```

I also have an *experimental* helper function. `overwrite_rows_in_table()` which will update existing rows in a table, but this one is not as robust or user-friendly as I would like. In my scripts, I usually have lots of checks on the data before and after using this function to confirm that it behaves as expected.

Other helpers
-------------

This package also provides some helper functions for working with our data. `undo_excel_date()` converts Excel's dates into R dates. `chrono_age()` computes the number of months (rounded down) between two dates, as you would when computing chronological age.

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

Repository structure
--------------------

This repository is an R package, so the `R/`, `man/` and `tests/` contain the source code, documentation, and unit tests for the package.

Most of the action is in the `inst/` directory. `inst/migrations/` contains R scripts that add data from our various spreadsheets and csv files to the database. `inst/audit/` contains some helper scripts that check for inconsistencys in our data. `inst/views/` contains the source code for our SQL queries used by the database.

Data audits
-----------

We have some scripts that audit our data-sets. The results of these checks are printed here.

| Check          | Date       | Passing | Result               | Link                                                             |
|:---------------|:-----------|:--------|:---------------------|:-----------------------------------------------------------------|
| EVT            | 2017-01-17 | TRUE    | :white\_check\_mark: | [EVT](inst/audit/audit-evt.md)                                   |
| PPVT           | 2017-01-17 | TRUE    | :white\_check\_mark: | [PPVT](inst/audit/audit-ppvt.md)                                 |
| Discrepancies  | 2017-01-17 | TRUE    | :white\_check\_mark: | [Data entry discrepancies](inst/audit/check_integrity.md)        |
| MySQL metadata | 2017-01-18 | TRUE    | :white\_check\_mark: | [MySQL metadata completeness](inst/audit/check_documentation.md) |

Study coverage
--------------

The following table summarizes how many scores/administrations of each task were collected for each study. It is included here to show which tasks and which studies have been migrated into the database.

    #> Joining, by = "BlockID"

| Table            | Study            |  Participants|  Administrations|
|:-----------------|:-----------------|-------------:|----------------:|
| Blending         | TimePoint2       |            65|               65|
| BRIEF            | CochlearMatching |             5|                5|
| BRIEF            | CochlearV1       |            24|               24|
| BRIEF            | CochlearV2       |             9|                9|
| BRIEF            | DialectDensity   |            12|               12|
| BRIEF            | DialectSwitch    |            41|               41|
| BRIEF            | LateTalker       |             9|                9|
| BRIEF            | MaternalEd       |             5|                5|
| BRIEF            | TimePoint1       |           209|              209|
| CTOPP\_Blending  | LateTalker       |             1|                1|
| CTOPP\_Blending  | MaternalEd       |             7|                7|
| CTOPP\_Blending  | TimePoint2       |            75|               75|
| CTOPP\_Blending  | TimePoint3       |           162|              162|
| CTOPP\_Elision   | LateTalker       |             1|                1|
| CTOPP\_Elision   | MaternalEd       |             7|                7|
| CTOPP\_Elision   | TimePoint2       |            75|               75|
| CTOPP\_Elision   | TimePoint3       |           162|              162|
| CTOPP\_Memory    | CochlearMatching |             3|                3|
| CTOPP\_Memory    | CochlearV1       |             2|                2|
| CTOPP\_Memory    | CochlearV2       |             4|                4|
| CTOPP\_Memory    | MaternalEd       |             4|                4|
| CTOPP\_Memory    | TimePoint3       |           162|              162|
| EVT              | CochlearMatching |             4|                4|
| EVT              | CochlearV1       |            24|               24|
| EVT              | CochlearV2       |            10|               10|
| EVT              | DialectDensity   |            12|               12|
| EVT              | DialectSwitch    |            43|               43|
| EVT              | LateTalker       |             7|                7|
| EVT              | MaternalEd       |            19|               19|
| EVT              | TimePoint1       |           201|              201|
| EVT              | TimePoint2       |           178|              178|
| EVT              | TimePoint3       |           164|              164|
| Eyetracking: MP  | TimePoint1       |           207|              399|
| Eyetracking: MP  | TimePoint2       |           181|              350|
| Eyetracking: MP  | TimePoint3       |           164|              326|
| Eyetracking: RWL | TimePoint1       |           205|              384|
| Eyetracking: RWL | TimePoint2       |           180|              347|
| Eyetracking: RWL | TimePoint3       |           163|              322|
| FruitStroop      | CochlearMatching |             1|                1|
| FruitStroop      | CochlearV1       |            22|               22|
| FruitStroop      | CochlearV2       |             6|                6|
| FruitStroop      | DialectDensity   |             8|                8|
| FruitStroop      | DialectSwitch    |            43|               43|
| FruitStroop      | LateTalker       |             7|                7|
| FruitStroop      | MaternalEd       |            16|               16|
| FruitStroop      | TimePoint1       |           209|              209|
| FruitStroop      | TimePoint2       |           178|              178|
| GFTA             | CochlearMatching |             1|                1|
| GFTA             | CochlearV1       |            24|               24|
| GFTA             | CochlearV2       |            10|               10|
| GFTA             | LateTalker       |             6|                6|
| GFTA             | MaternalEd       |            16|               16|
| GFTA             | TimePoint1       |           176|              176|
| GFTA             | TimePoint3       |           156|              156|
| LENA             | CochlearMatching |             1|                1|
| LENA             | CochlearV1       |            21|               21|
| LENA             | CochlearV2       |             7|                7|
| LENA             | DialectSwitch    |            30|               30|
| LENA             | LateTalker       |             6|                6|
| LENA             | MaternalEd       |            13|               13|
| LENA             | TimePoint1       |           182|              182|
| LENA             | TimePoint2       |           140|              140|
| LENA             | TimePoint3       |             1|                1|
| MinPair          | CochlearMatching |             3|                3|
| MinPair          | CochlearV1       |            24|               24|
| MinPair          | CochlearV2       |            10|               10|
| MinPair          | DialectSwitch    |            43|               84|
| MinPair          | LateTalker       |             9|                9|
| MinPair          | MaternalEd       |            13|               25|
| MinPair          | TimePoint1       |           190|              190|
| MinPair          | TimePoint2       |            94|               94|
| MinPair          | TimePoint3       |             3|                3|
| PPVT             | CochlearMatching |             4|                4|
| PPVT             | CochlearV1       |            24|               24|
| PPVT             | CochlearV2       |            10|               10|
| PPVT             | DialectDensity   |             6|                6|
| PPVT             | DialectSwitch    |            44|               44|
| PPVT             | LateTalker       |             7|                7|
| PPVT             | MaternalEd       |            21|               21|
| PPVT             | TimePoint1       |           200|              200|
| PPVT             | TimePoint2       |           180|              180|
| PPVT             | TimePoint3       |            29|               29|
| Rhyming          | TimePoint2       |            69|               69|
| SAILS            | CochlearMatching |             2|                2|
| SAILS            | CochlearV1       |            11|               11|
| SAILS            | CochlearV2       |             8|                8|
| SAILS            | LateTalker       |             5|                5|
| SAILS            | MaternalEd       |            10|               10|
| SAILS            | TimePoint2       |           161|              161|
| SAILS            | TimePoint3       |           156|              156|
| VerbalFluency    | CochlearMatching |             3|                3|
| VerbalFluency    | CochlearV1       |            23|               23|
| VerbalFluency    | CochlearV2       |            10|               10|
| VerbalFluency    | LateTalker       |             9|                9|
| VerbalFluency    | MaternalEd       |            20|               20|
| VerbalFluency    | TimePoint1       |           196|              196|
| VerbalFluency    | TimePoint2       |           179|              179|
| VerbalFluency    | TimePoint3       |           161|              161|
