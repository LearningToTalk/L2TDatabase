CI Matching table demo
================
TJ Mahr
April 26, 2017

Data lives in `CIMatching` table in `l2t` database.

``` r
library(dplyr, warn.conflicts = FALSE)
library(L2TDatabase)

# Connect to db
config_file <- "./inst/l2t_db.cnf"
l2t <- l2t_connect(config_file, "l2t")

# Download matches
matches <- collect(tbl(l2t, "CIMatching"))
glimpse(matches)
#> Observations: 82
#> Variables: 13
#> $ Study                    <chr> "CochlearV1", "CochlearV1", "Cochlear...
#> $ ResearchID               <chr> "300E", "301E", "302E", "302E", "303E...
#> $ Matching_Group           <chr> "CochlearImplant", "CochlearImplant",...
#> $ Matching_PairNumber      <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12...
#> $ ChildID                  <int> 284, 285, 286, 286, 287, 288, 288, 28...
#> $ ChildStudyID             <int> 789, 790, 791, 806, 792, 793, 807, 79...
#> $ HouseholdID              <int> 117, 129, 130, 130, 131, 132, 132, 13...
#> $ Female                   <int> 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1...
#> $ CImplant                 <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
#> $ Maternal_Caregiver       <chr> "Mother", "Mother", "Mother", "Mother...
#> $ Maternal_Education       <chr> "College Degree", "Technical/Associat...
#> $ Maternal_Education_Level <int> 6, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 6...
#> $ EVT_Age                  <int> 57, 53, 37, 49, 65, 48, 59, 44, 56, 4...
```

Confirm some matching:

``` r
matches %>% 
  group_by(Matching_Group) %>% 
  summarise(
    N_Children = n_distinct(ChildID),
    N_StudyParticipations = n_distinct(ChildStudyID), 
    Mean_Age = mean(EVT_Age)) %>% 
  knitr::kable()
```

| Matching\_Group |  N\_Children|  N\_StudyParticipations|  Mean\_Age|
|:----------------|------------:|-----------------------:|----------:|
| CochlearImplant |           26|                      41|   50.09756|
| NormalHearing   |           26|                      41|   50.09756|

``` r

# Keep distinct ChildIDs so children are not counted twice when counting male
# and female
matches %>% 
  distinct(Matching_Group, Female, ChildID) %>% 
  count(Matching_Group, Female) %>% 
  ungroup() %>% 
  mutate(Female = ifelse(Female, "Female", "Male")) %>% 
  rename(Gender = Female) %>% 
  kable()
```

| Matching\_Group | Gender |    n|
|:----------------|:-------|----:|
| CochlearImplant | Male   |   11|
| CochlearImplant | Female |   15|
| NormalHearing   | Male   |   11|
| NormalHearing   | Female |   15|
