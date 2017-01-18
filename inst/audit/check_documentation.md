Documentation Check
================
Tristan Mahr
2017-01-17

MySQL allows users to write short documentation comments for database tables (up to 80 characters) and for database fields (up to 255 characters). These documentation comments can be queried and retrieved like other data, so they provide a handy way to store descriptive metadata.

This script checks for missing documentation in database.

### Preliminaries

``` r
# Connect to the scores database
library("L2TDatabase")
library("dplyr")

cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file, "backend")
```

### We cannot document views

*Views* are tables that are dynamically show the results of a query. These are prefixed in the database with "q\_" (for *query*). These view tables, and the derived fields computer in them, cannot be documented. We have to ignore these tables in our check

The following tables are views and can only have have limited documentation.

``` r
describe_db(l2t) %>% 
  filter(Description == "VIEW")
#>    Database                              Table Rows Description
#> 1   backend       q_Blending_ModulePropCorrect   NA        VIEW
#> 2   backend             q_Blending_PropCorrect   NA        VIEW
#> 3   backend                 q_Blending_Summary   NA        VIEW
#> 4   backend      q_Blending_SupportPropCorrect   NA        VIEW
#> 5   backend              q_Household_Education   NA        VIEW
#> 6   backend     q_Household_Maternal_Caregiver   NA        VIEW
#> 7   backend q_Household_Max_Maternal_Education   NA        VIEW
#> 8   backend                    q_LENA_Averages   NA        VIEW
#> 9   backend                q_MinPair_Aggregate   NA        VIEW
#> 10  backend                q_Rhyming_Aggregate   NA        VIEW
#> 11  backend              q_Rhyming_PropCorrect   NA        VIEW
#> 12  backend                  q_SAILS_Aggregate   NA        VIEW
#> 13  backend                q_SAILS_PropCorrect   NA        VIEW
```

In the `q_MinPair_Aggregate` view, the proportion correct for non-training trials is a derived value. The field `MinPair_ProportionCorrect` is created and computed as the query is executed. Therefore, there is no documentation available for it.

``` r
l2t %>% 
  describe_tbl("q_MinPair_Aggregate") %>% 
  filter(Description == "")
#>                 Table                     Field Index     DataType
#> 1 q_MinPair_Aggregate     MinPair_NumTestTrials         bigint(21)
#> 2 q_MinPair_Aggregate MinPair_ProportionCorrect       decimal(7,4)
#>   DefaultValue NullAllowed Description
#> 1            0          NO            
#> 2         <NA>         YES
```

Undocumented Tables
-------------------

The following tables are missing documentation:

``` r
no_table_doc <- describe_db(l2t) %>% filter(Description == "")
no_table_doc
#>   Database      Table Rows Description
#> 1  backend ChildStudy  697            
#> 2  backend  Household  298            
#> 3  backend   Literacy  207            
#> 4  backend      Study   10
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
  bind_rows() %>% 
  as_data_frame()

# Keep only undocumented rows
undocumented_fields <- all_descriptions %>% 
  # Ignore the temporary tables used for mass data-entry
  mutate(IsEntryTable = stringr::str_detect(Table, "_Entry")) %>% 
  filter(Description == "", !IsEntryTable) %>% 
  select(Table, Field, Description) %>% 
  print(n = Inf)
#> # A tibble: 0 × 3
#> # ... with 3 variables: Table <chr>, Field <chr>, Description <chr>
undocumented_fields
#> # A tibble: 0 × 3
#> # ... with 3 variables: Table <chr>, Field <chr>, Description <chr>
```

Name checks
-----------

We need to be careful about tables that share field names because they will not join correctly. For example, trying to combine an Experiment table with a `Dialect` column to a ParticipantInfo table with `Dialect` column will wrongly combine experiments and children that share the same values in the Dialect column. Which is not what we want, especially the same child is exposed to different versions of an experiment with different dialects.

Ideally, only index fields should be allowed to appear in more than one table, and we check that this is the case. We allow tables for item-level data to have repeated names (like Trial or Stimulus1), so we ignore tables with `_Responses` in the name.

``` r
# Get description of each non-view table. Combine them.
repeated_names <- all_descriptions %>% 
  # Ignore the temporary tables used for mass data-entry
  mutate(IsEntryTable = stringr::str_detect(Table, "_Entry"),
         IsItemTable = stringr::str_detect(Table, "_Responses")) %>% 
  filter(Index == "", !IsEntryTable, !IsItemTable) %>% 
  # Count the occurrence of each field
  group_by(Field) %>% 
  mutate(FieldCount = length(Field)) %>% 
  ungroup() %>% 
  # Keep duplicated fields
  filter(FieldCount != 1) %>% 
  select(Field, Table) %>% 
  arrange(Field) %>% 
  print(n = Inf)
#> # A tibble: 0 × 2
#> # ... with 2 variables: Field <chr>, Table <chr>
repeated_names
#> # A tibble: 0 × 2
#> # ... with 2 variables: Field <chr>, Table <chr>
```
