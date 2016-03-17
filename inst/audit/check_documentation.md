Documentation Check
================
Tristan Mahr
2016-03-17

MySQL allows users to write short documentation comments for database tables (up to 80 characters) and for database fields (up to 255 characters). These documentation comments can be queried and retrieved like other data, so they provide a handy way to store descriptive metadata.

This script checks for missing documentation in database.

### Preliminaries

``` r
# Connect to the scores database
library("L2TDatabase")
library("dplyr")

cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file)
```

### We cannot document views

*Views* are tables that are dynamically show the results of a query. These are prefixed in the database with "q\_" (for *query*). These view tables, and the derived fields computer in them, cannot be documented. We have to ignore these tables in our check

The following tables are views and can only have have limited documentation.

``` r
describe_db(l2t) %>% 
  filter(Description == "VIEW")
#>   Database               Table Rows Description
#> 1      l2t q_MinPair_Aggregate   NA        VIEW
#> 2      l2t q_Scores_TimePoint1   NA        VIEW
#> 3      l2t q_Scores_TimePoint2   NA        VIEW
#> 4      l2t q_Scores_TimePoint3   NA        VIEW
```

In the `q_MinPair_Aggregate` view, the proportion correct for non-training trials is a derived value. The field `MinPair_ProportionCorrect` is created and computed as the query is executed. Therefore, there is no documentation available for it.

``` r
l2t %>% 
  describe_tbl("q_MinPair_Aggregate") %>% 
  filter(Description == "")
#>                 Table                     Field Index     DataType
#> 1 q_MinPair_Aggregate MinPair_ProportionCorrect       decimal(7,4)
#>   DefaultValue NullAllowed Description
#> 1         <NA>         YES
```

Undocumented Tables
-------------------

The following tables are missing documentation:

``` r
describe_db(l2t) %>% 
  filter(Description == "")
#>   Database         Table Rows Description
#> 1      l2t    ChildStudy  559            
#> 2      l2t   FruitStroop    0            
#> 3      l2t      Literacy  207            
#> 4      l2t         Study    3            
#> 5      l2t VerbalFluency    0
```

Undocumented Fields
-------------------

The following fields are missing documentation.

``` r
# Omit strings containing a pattern
str_reject <- function(string, pattern) { 
  string[!stringr::str_detect(string, pattern)]
}

non_view_tbls <- src_tbls(l2t) %>% str_reject("q_")

# Get description of each non-view table. Combine them.
all_descriptions <- Map(function(x) describe_tbl(l2t, x), non_view_tbls) %>% 
  bind_rows 

# Keep only undocumented rows
all_descriptions %>% 
  filter(Description == "") %>% 
  select(Table, Field, Description) %>% 
  print(n = nrow(.))
#> Source: local data frame [17 x 3]
#> 
#>            Table                            Field Description
#>            (chr)                            (chr)       (chr)
#> 1      SES_Entry                            SESID            
#> 2      SES_Entry                  SESID_Timestamp            
#> 3      SES_Entry                       ResearchID            
#> 4      SES_Entry                  Child_Ethnicity            
#> 5      SES_Entry                       Child_Race            
#> 6      SES_Entry                Household_Under18            
#> 7      SES_Entry                 Household_Adults            
#> 8      SES_Entry Household_AdultsContributeIncome            
#> 9      SES_Entry           Household_FamilyIncome            
#> 10     SES_Entry          Household_MaritalStatus            
#> 11     SES_Entry                        SES_Notes            
#> 12 VerbalFluency                  VerbalFluencyID            
#> 13 VerbalFluency                     ChildStudyID            
#> 14 VerbalFluency          VerbalFluency_Timestamp            
#> 15 VerbalFluency         VerbalFluency_Completion            
#> 16 VerbalFluency                VerbalFluency_Raw            
#> 17 VerbalFluency              VerbalFluency_AgeEq
```

Name checks
-----------

We need to be careful about tables that share field names because they will not join correctly. For example, trying to combine an Experiment table with a `Dialect` column to a ParticipantInfo table with `Dialect` column will wrongly combine experiments and children that share the same values in the Dialect column. Which is not what we want, especially the same child is exposed to different versions of an experiment with different dialects.

Ideally, only index fields should be allowed to appear in more than one table, and we check that this is the case:

``` r
# Get description of each non-view table. Combine them.
all_descriptions %>% 
  # Ignore the temporary tables used for mass data-entry
  mutate(IsEntryTable = stringr::str_detect(Table, "_Entry")) %>% 
  filter(Index == "", !IsEntryTable) %>% 
  # Count the occurrence of each field
  group_by(Field) %>% 
  mutate(FieldCount = length(Field)) %>% 
  ungroup %>% 
  # Keep duplicated fields
  filter(FieldCount != 1) %>% 
  select(Field, Table) %>% 
  arrange(Field) %>% 
  print(n = nrow(.))
#> Source: local data frame [0 x 2]
#> 
#> Variables not shown: Field (chr), Table (chr)
```
