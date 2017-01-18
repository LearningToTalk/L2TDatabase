EVT Score Audit
================
Tristan Mahr
Tue Jan 17 20:22:04 2017

Script to check for inconsistencies in the EVT scores in the database.

``` r
# Connect to db
library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)
cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file, "backend")

# Combine child, study, childstudy, and evts tbls
evts <- tbl(l2t, "ChildStudy")  %>%
  left_join("Study" %from% l2t) %>%
  left_join("Child" %from% l2t) %>%
  left_join("EVT" %from% l2t) %>%
  # Download rows for kids with raw scores
  filter(!is.na(EVT_Raw)) %>%
  select(Study, ID = ShortResearchID, Birthdate, EVT_Form:EVT_Age) %>%
  collect

# Download Form A norms
evt_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("EVT2") %>%
  collect

# Make a form of the table amenable for score checking
norm_check <- evts %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(EVT_Age < 30, 30, EVT_Age)) %>%
  rename(Raw = EVT_Raw, OurStnd = EVT_Standard, OurGSV = EVT_GSV) %>%
  select(-EVT_Age, -Birthdate, -EVT_Completion)
```

Preliminary checks
------------------

### Missing Dates

``` r
evts %>%
  filter(is.na(EVT_Completion)) %>%
  select(Study:EVT_Completion)
#> # A tibble: 0 × 5
#> # ... with 5 variables: Study <chr>, ID <chr>, Birthdate <chr>,
#> #   EVT_Form <chr>, EVT_Completion <chr>
```

### Missing Forms

There should be lots of missing forms because both sites haven't documented the test form consistently.

``` r
evts %>%
  filter(is.na(EVT_Form)) %>%
  select(Study:EVT_Completion) %>%
  arrange(Study, ID) %>%
  # Print every row
  as.data.frame
#> [1] Study          ID             Birthdate      EVT_Form      
#> [5] EVT_Completion
#> <0 rows> (or 0-length row.names)
```

### Ages

Recompute test ages and compare to age in EVT table

``` r
evts %>%
  select(Study, ID, Birthdate, EVT_Completion, EVT_Age) %>%
  filter(!is.na(EVT_Completion)) %>%
  mutate(ChronoAge = chrono_age(Birthdate, EVT_Completion)) %>%
  filter(EVT_Age != ChronoAge) %>%
  select(-Birthdate)
#> # A tibble: 0 × 5
#> # ... with 5 variables: Study <chr>, ID <chr>, EVT_Completion <chr>,
#> #   EVT_Age <int>, ChronoAge <dbl>
```

Derived Scores
--------------

### Form B scores

We cannot automatically check these scores because we only have the Form A norms.

``` r
norm_check %>% filter(EVT_Form == "B")
#> # A tibble: 8 × 7
#>        Study    ID EVT_Form   Raw OurStnd OurGSV   Age
#>        <chr> <chr>    <chr> <int>   <int>  <int> <dbl>
#> 1 TimePoint1  600L        B    69     141    141    37
#> 2 TimePoint1  602L        B    43     117    120    34
#> 3 TimePoint1  603L        B    70     143    142    36
#> 4 TimePoint1  607L        B    41     110    119    36
#> 5 TimePoint2  600L        B    93     144    157    49
#> 6 TimePoint2  602L        B    52     104    128    46
#> 7 TimePoint2  603L        B   103     156    163    47
#> 8 TimePoint2  607L        B    63     114    137    49
```

### Form A checks

``` r
# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(EVT_Form %in% "A") %>%
  left_join(evt_norms) %>%
  select(Study:EVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)
```

#### GSVs

``` r
form_a_gsv <- form_a %>% filter(OurGSV != GSV)
form_a_gsv
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

#### Standard Scores

``` r
form_a_std <- form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_a_std
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

### Form NA checks

Assume that all tests with missing forms are just Form A tests.

``` r
form_na <- norm_check %>%
  filter(is.na(EVT_Form)) %>%
  left_join(evt_norms) %>%
  select(Study:EVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)
```

#### GSVs

``` r
form_na_gsv <- form_na %>% filter(OurGSV != GSV)
form_na_gsv
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

#### Standard Scores

``` r
form_na_std <- form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_na_std
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>


results <- bind_rows(form_na_gsv, form_na_std, form_a_std, form_a_gsv)

results <- data_frame(
  Check = "EVT",
  Date = format(Sys.Date()),
  Passing = nrow(results) == 0)

readr::write_csv(results, "./inst/audit/results_evt.csv")
```
