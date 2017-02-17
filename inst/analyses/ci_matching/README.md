Finding normal-hearing matches for children with cochlear implants
================
Tristan Mahr
2017-02-17

Find children who need matches
------------------------------

Connect to database:

``` r
library(dplyr)
library(L2TDatabase)

# Work relative to RStudio project
wd <- rprojroot::find_rstudio_root_file()
dir_here <- file.path(wd, "inst", "analyses", "ci_matching")
cnf_file <- file.path(wd, "inst", "l2t_db.cnf")

l2t_main <- l2t_connect(cnf_file, "l2t")
l2t_backend <- l2t_connect(cnf_file, "backend")
l2t_eyetracking <- l2t_connect(cnf_file, "eyetracking")
```

Starting pool for matching: Children at TimePoint1 who

-   speak Mainstream American English at home
-   do not have cochlear implants
-   are not late talkers
-   have an EVT score
-   have a maternal education entry in the database

We also recruited some non-longitudinal participants to serve as age-matches for the children with cochlear implants in our CochlearMatching study, so we gather those participants as well and filter them with the same criteria.

``` r
apply_nh_matching_criteria <- . %>% 
  filter(!AAE, !CImplant, !LateTalker, 
         !is.na(EVT_Standard), !is.na(Maternal_Education))
  
nh_set1 <- tbl(l2t_main, "Scores_TimePoint1") %>% 
  apply_nh_matching_criteria() %>% 
  collect()

nh_set2 <- tbl(l2t_main, "Scores_CochlearMatching") %>% 
  apply_nh_matching_criteria() %>% 
  collect()

nh_set <- bind_rows(nh_set1, nh_set2)
```

Post-stratify by maternal education. First, define low-mid-high medu groups. This coding scheme uses the unusual convention of lumping the two families with less than two years of college education in the low-education group.

``` r
medu_scheme <- data_frame(
  Maternal_Education_Level = c(NA, 1:7),
  Maternal_Education_Group = c(NA, "Low", "Low", "Low", "Low", 
                               "Mid", "Mid", "High")
)

nh_set <- left_join(nh_set, medu_scheme, by = "Maternal_Education_Level")

nh_set %>% 
  count(Maternal_Education, Maternal_Education_Level, 
        Maternal_Education_Group) %>% 
  arrange(Maternal_Education_Level)
#> Source: local data frame [9 x 4]
#> Groups: Maternal_Education, Maternal_Education_Level [9]
#> 
#>             Maternal_Education Maternal_Education_Level
#>                          <chr>                    <int>
#> 1        Less Than High School                        1
#> 2                          GED                        2
#> 3          High School Diploma                        3
#> 4      Some College (<2 years)                        4
#> 5      Some College (2+ years)                        5
#> 6 Technical/Associate's Degree                        5
#> 7                 Trade School                        5
#> 8               College Degree                        6
#> 9              Graduate Degree                        7
#> # ... with 2 more variables: Maternal_Education_Group <chr>, n <int>
```

Find the vocabulary scores that would define the 10-90% range for each maternal education group.

``` r
nh_vocab_limits <- nh_set %>% 
  group_by(Maternal_Education_Group) %>% 
  summarise(
    n = n(),
    EVT_Mean = mean(EVT_Standard),
    EVT_Min = min(EVT_Standard), 
    EVT_Max = max(EVT_Standard),
    EVT_10 = quantile(EVT_Standard, .1),
    EVT_90 = quantile(EVT_Standard, .9),
    nInRange = sum(between(EVT_Standard, EVT_10, EVT_90))) %>% 
  ungroup()

nh_vocab_limits
#> # A tibble: 3 × 8
#>   Maternal_Education_Group     n EVT_Mean EVT_Min EVT_Max EVT_10 EVT_90
#>                      <chr> <int>    <dbl>   <int>   <int>  <dbl>  <dbl>
#> 1                     High    71 123.2113      96     146  110.0  134.0
#> 2                      Low     9 110.0000      83     151   92.6  132.6
#> 3                      Mid    84 116.5833      83     160   97.2  132.7
#> # ... with 1 more variables: nInRange <int>
```

Restrict pool to just children with scores in their range.

``` r
# N before
nrow(nh_set)
#> [1] 164

nh_filtered <- nh_set %>% 
  left_join(nh_vocab_limits) %>% 
  rowwise() %>% 
  mutate(InRange = between(EVT_Standard, EVT_10, EVT_90)) %>% 
  ungroup() %>% 
  filter(InRange)

# N after
nrow(nh_filtered)
#> [1] 131
```

Children who can be matches who were tested at Timepoint1 should not have received the first bad version of the eyetracking experiment with the timing glitch. Identify children to exclude from matching because they had a nonstandard version of an eyetracking experiment.

``` r
children_with_bad_blocks <- tbl(l2t_eyetracking, "q_BlocksByStudy") %>% 
  filter(Version != "Standard") %>% 
  distinct(Study, ResearchID) %>% 
  collect()
children_with_bad_blocks
#> # A tibble: 35 × 2
#>         Study ResearchID
#>         <chr>      <chr>
#> 1  TimePoint1       002L
#> 2  TimePoint1       003L
#> 3  TimePoint1       004L
#> 4  TimePoint1       005L
#> 5  TimePoint1       007L
#> 6  TimePoint1       008L
#> 7  TimePoint1       009L
#> 8  TimePoint1       010L
#> 9  TimePoint1       012L
#> 10 TimePoint1       015L
#> # ... with 25 more rows
```

Also take into account missing data for each eyetracking task.

``` r
missing_data_stats_raw <- tbl(l2t_eyetracking, "q_MissingDataByBlock") %>% 
  collect()

missing_data_stats <- missing_data_stats_raw %>% 
  filter(Version == "Standard") %>% 
  group_by(Study, ResearchID, Task) %>% 
  summarise(MinMissing = min(ProportionMissing),
            NUseableBlocks = sum(ProportionMissing < .5)) %>% 
  ungroup()
missing_data_stats
#> # A tibble: 1,237 × 5
#>               Study ResearchID  Task MinMissing NUseableBlocks
#>               <chr>      <chr> <chr>      <dbl>          <int>
#> 1  CochlearMatching       390A    MP     0.0080              2
#> 2  CochlearMatching       390A   RWL     0.0059              2
#> 3  CochlearMatching       391A    MP     0.1230              1
#> 4  CochlearMatching       391A   RWL     0.1843              1
#> 5  CochlearMatching       392A   RWL     0.0393              2
#> 6  CochlearMatching       393A    MP     0.0220              2
#> 7  CochlearMatching       393A   RWL     0.0461              2
#> 8  CochlearMatching       394A    MP     0.0498              2
#> 9  CochlearMatching       394A   RWL     0.0537              2
#> 10       CochlearV1       300E    MP     0.2865              2
#> # ... with 1,227 more rows
```

Accounting for multiple visits
------------------------------

Get the participation of children across multiple studies.

``` r
childstudy <- tbl(l2t_backend, "ChildStudy") %>% 
  left_join(tbl(l2t_backend, "Study")) %>% 
  select(ChildID, ChildStudyID, ResearchID = ShortResearchID, Study) %>% 
  collect()

childstudy
#> # A tibble: 697 × 4
#>    ChildID ChildStudyID ResearchID      Study
#>      <int>        <int>      <chr>      <chr>
#> 1       23            1       600L TimePoint1
#> 2       24            2       601L TimePoint1
#> 3       25            3       602L TimePoint1
#> 4       26            4       603L TimePoint1
#> 5       27            5       604L TimePoint1
#> 6       28            6       605L TimePoint1
#> 7       29            7       606L TimePoint1
#> 8       30            8       607L TimePoint1
#> 9       31            9       608L TimePoint1
#> 10      32           10       609L TimePoint1
#> # ... with 687 more rows
```

Get study participation for children in the NH matching pool.

``` r
nh_childstudy <- childstudy %>% 
  semi_join(select(nh_filtered, ChildID))
nh_childstudy
#> # A tibble: 355 × 4
#>    ChildID ChildStudyID ResearchID      Study
#>      <int>        <int>      <chr>      <chr>
#> 1      151          129       002L TimePoint1
#> 2      151          328       002L TimePoint2
#> 3      151          569       002L TimePoint3
#> 4      152          130       003L TimePoint1
#> 5      152          570       003L TimePoint3
#> 6      153          131       004L TimePoint1
#> 7      153          329       004L TimePoint2
#> 8      153          571       004L TimePoint3
#> 9      154          132       005L TimePoint1
#> 10     154          330       005L TimePoint2
#> # ... with 345 more rows
```

Remove the child-study pairs for children with the bad eyetracking.

``` r
no_useable_blocks <- missing_data_stats %>% 
  group_by(Study, ResearchID) %>% 
  filter(sum(NUseableBlocks) == 0) %>% 
  ungroup()
no_useable_blocks
#> # A tibble: 41 × 5
#>         Study ResearchID  Task MinMissing NUseableBlocks
#>         <chr>      <chr> <chr>      <dbl>          <int>
#> 1  CochlearV1       800E    MP     0.5677              0
#> 2  CochlearV1       800E   RWL     0.8444              0
#> 3  TimePoint1       033L    MP     0.6944              0
#> 4  TimePoint1       033L   RWL     0.8289              0
#> 5  TimePoint1       079L    MP     0.6584              0
#> 6  TimePoint1       079L   RWL     0.5565              0
#> 7  TimePoint1       127L    MP     0.6871              0
#> 8  TimePoint1       127L   RWL     0.6980              0
#> 9  TimePoint1       619L    MP     0.5466              0
#> 10 TimePoint1       619L   RWL     0.7366              0
#> # ... with 31 more rows

nh_childstudy <- nh_childstudy %>% 
  anti_join(children_with_bad_blocks) %>% 
  anti_join(no_useable_blocks)
nh_childstudy
#> # A tibble: 324 × 4
#>    ChildID ChildStudyID ResearchID      Study
#>      <int>        <int>      <chr>      <chr>
#> 1       39          277       616L TimePoint2
#> 2       39          529       616L TimePoint3
#> 3      191          169       042L TimePoint1
#> 4      191          366       042L TimePoint2
#> 5      191          604       042L TimePoint3
#> 6       49           27       626L TimePoint1
#> 7      201          611       052L TimePoint3
#> 8      201          179       052L TimePoint1
#> 9      201          375       052L TimePoint2
#> 10     241          407       092L TimePoint2
#> # ... with 314 more rows
```

Get the information for matching.

``` r
d_tp1 <- tbl(l2t_main, "Scores_TimePoint1") %>% collect()
d_tp2 <- tbl(l2t_main, "Scores_TimePoint2") %>% collect()
d_tp3 <- tbl(l2t_main, "Scores_TimePoint3") %>% collect()
d_matching <- tbl(l2t_main, "Scores_CochlearMatching") %>% collect()
d_ci1 <- tbl(l2t_main, "Scores_CochlearV1") %>% collect()
d_ci2 <- tbl(l2t_main, "Scores_CochlearV2") %>% collect()

# Get age, Sex, Medu for everyone
matching_vars <- bind_rows(d_tp1, d_tp2, d_tp3, d_ci1, d_ci2, d_matching) %>% 
  mutate(Age = EVT_Age,
         Age = ifelse(is.na(Age), PPVT_Age, Age), 
         Age = ifelse(is.na(Age), FruitStroop_Age, Age)) %>% 
  select(ChildID, ChildStudyID, Study, Age, 
         Female, CImplant, AAE, LateTalker, ResearchID, 
         Maternal_Education, Maternal_Education_Level) %>% 
  left_join(medu_scheme, by = "Maternal_Education_Level")

# Number the study visits
nh_matching <- matching_vars %>% 
  semi_join(nh_childstudy) %>% 
  group_by(ChildID) %>% 
  arrange(Age) %>% 
  mutate(NumVisits = length(ChildStudyID),
         VisitNum = seq_along(Age)) %>% 
  ungroup() %>% 
  arrange(ChildID, VisitNum) %>% 
  select(-ChildStudyID) %>% 
  select(ChildID, ResearchID, Study, Age, VisitNum, NumVisits, everything())

# Also include information about eyetracking data
useable_blocks_per_childstudy <- missing_data_stats %>% 
  tidyr::gather(Variable, Value, MinMissing:NUseableBlocks) %>% 
  filter(Variable == "NUseableBlocks") %>% 
  tidyr::complete(tidyr::nesting(Study, ResearchID), Task, Variable, 
                  fill = list(Value = 0)) %>% 
  tidyr::unite(Variable, Task, Variable) %>% 
  tidyr::spread(Variable, Value)

nh_matching <- nh_matching %>% 
  left_join(useable_blocks_per_childstudy)
nh_matching
#> # A tibble: 324 × 15
#>    ChildID ResearchID      Study   Age VisitNum NumVisits Female CImplant
#>      <int>      <chr>      <chr> <int>    <int>     <int>  <int>    <int>
#> 1       25       602L TimePoint2    46        1         2      0        0
#> 2       25       602L TimePoint3    58        2         2      0        0
#> 3       27       604L TimePoint2    42        1         2      1        0
#> 4       27       604L TimePoint3    55        2         2      1        0
#> 5       29       606L TimePoint2    47        1         1      0        0
#> 6       30       607L TimePoint2    49        1         2      0        0
#> 7       30       607L TimePoint3    61        2         2      0        0
#> 8       34       611L TimePoint2    47        1         2      0        0
#> 9       34       611L TimePoint3    59        2         2      0        0
#> 10      35       612L TimePoint2    43        1         2      1        0
#> # ... with 314 more rows, and 7 more variables: AAE <int>,
#> #   LateTalker <int>, Maternal_Education <chr>,
#> #   Maternal_Education_Level <int>, Maternal_Education_Group <chr>,
#> #   MP_NUseableBlocks <dbl>, RWL_NUseableBlocks <dbl>

ci_matching <- matching_vars %>% 
  # Exclude 079L's Timepoint1 visit because they were moved from the
  # longitudinal study tract to the CochlearV1/CochlearV2 tract.
  filter(CImplant == 1, ResearchID != "079L") %>% 
  group_by(ChildID) %>% 
  arrange(Age) %>% 
  mutate(NumVisits = length(ChildStudyID),
         VisitNum = seq_along(Age)) %>% 
  ungroup() %>% 
  arrange(ChildID, VisitNum) %>% 
  select(-ChildStudyID) %>% 
  select(ChildID, ResearchID, Study, Age, VisitNum, NumVisits, everything()) %>% 
  left_join(useable_blocks_per_childstudy)
ci_matching
#> # A tibble: 46 × 15
#>    ChildID ResearchID      Study   Age VisitNum NumVisits Female CImplant
#>      <int>      <chr>      <chr> <int>    <int>     <int>  <int>    <int>
#> 1       28       605L TimePoint1    31        1         3      0        1
#> 2       28       605L TimePoint2    43        2         3      0        1
#> 3       28       605L TimePoint3    55        3         3      0        1
#> 4       31       608L TimePoint1    39        1         3      1        1
#> 5       31       608L TimePoint2    55        2         3      1        1
#> 6       31       608L TimePoint3    64        3         3      1        1
#> 7       88       665L TimePoint1    40        1         3      1        1
#> 8       88       665L TimePoint2    52        2         3      1        1
#> 9       88       665L TimePoint3    66        3         3      1        1
#> 10     102       679L TimePoint1    34        1         3      0        1
#> # ... with 36 more rows, and 7 more variables: AAE <int>,
#> #   LateTalker <int>, Maternal_Education <chr>,
#> #   Maternal_Education_Level <int>, Maternal_Education_Group <chr>,
#> #   MP_NUseableBlocks <dbl>, RWL_NUseableBlocks <dbl>

readr::write_csv(nh_matching, "nh_matching_info.csv")
readr::write_csv(ci_matching, "ci_matching_info.csv")
```
