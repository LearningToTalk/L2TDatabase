PPVT Score Audit
================
Tristan Mahr
Tue Jan 17 20:22:15 2017

Script to check for inconsistencies in the PPVT scores in the database.

``` r
# Connect to db
library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)
cnf_file <- "inst/l2t_db.cnf"
l2t <- l2t_connect(cnf_file, "backend")

# Combine child, study, childstudy, and ppvts tbls
ppvts <- tbl(l2t, "ChildStudy")  %>%
  left_join("Study" %from% l2t) %>%
  left_join("Child" %from% l2t) %>%
  left_join("PPVT" %from% l2t) %>%
  # Download rows for kids with raw scores
  filter(!is.na(PPVT_Raw)) %>%
  select(Study, ID = ShortResearchID, Birthdate, PPVT_Form:PPVT_Age) %>%
  collect

# Download Form A norms
ppvt_norms <- l2t_connect(cnf_file, "norms") %>%
  tbl("PPVT4") %>%
  collect

# Make a form of the table amenable for score checking
norm_check <- ppvts %>%
  # Round age up to 30 months if younger than test norms
  mutate(Age = ifelse(PPVT_Age < 30, 30, PPVT_Age)) %>%
  rename(Raw = PPVT_Raw, OurStnd = PPVT_Standard, OurGSV = PPVT_GSV) %>%
  select(-PPVT_Age, -Birthdate, -PPVT_Completion)
```

Preliminary checks
------------------

### Missing Dates

``` r
ppvts %>%
  filter(is.na(PPVT_Completion)) %>%
  select(Study:PPVT_Completion)
#> # A tibble: 0 × 5
#> # ... with 5 variables: Study <chr>, ID <chr>, Birthdate <chr>,
#> #   PPVT_Form <chr>, PPVT_Completion <chr>
```

### Missing Forms

There should be lots of missing forms because both sites haven't documented the test form consistently.

``` r
ppvts %>%
  filter(is.na(PPVT_Form)) %>%
  select(Study:PPVT_Completion) %>%
  arrange(Study, ID) %>%
  # Print every row
  as.data.frame
#> [1] Study           ID              Birthdate       PPVT_Form      
#> [5] PPVT_Completion
#> <0 rows> (or 0-length row.names)
```

### Ages

Recompute test ages and compare to age in PPVT table

``` r
ppvts %>%
  select(Study, ID, Birthdate, PPVT_Completion, PPVT_Age) %>%
  filter(!is.na(PPVT_Completion)) %>%
  mutate(ChronoAge = chrono_age(Birthdate, PPVT_Completion)) %>%
  filter(PPVT_Age != ChronoAge) %>%
  select(-Birthdate)
#> # A tibble: 0 × 5
#> # ... with 5 variables: Study <chr>, ID <chr>, PPVT_Completion <chr>,
#> #   PPVT_Age <int>, ChronoAge <dbl>
```

Derived Scores
--------------

### Form B scores

We cannot automatically check these scores because we only have the Form A norms.

``` r
norm_check %>% filter(PPVT_Form == "B")
#> # A tibble: 3 × 7
#>        Study    ID PPVT_Form   Raw OurStnd OurGSV   Age
#>        <chr> <chr>     <chr> <int>   <int>  <int> <dbl>
#> 1 TimePoint1  600L         B    94     140    136    37
#> 2 TimePoint2  600L         B   136     152    164    49
#> 3 TimePoint2  126L         B    94     137    136    39
```

### Form A checks

``` r
# Get norms for each Age, Raw Score
form_a <- norm_check %>%
  filter(PPVT_Form %in% "A") %>%
  left_join(ppvt_norms) %>%
  select(Study:PPVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)
```

#### GSVs

``` r
form_a_gsv <- form_a %>% filter(OurGSV != GSV)
form_a_gsv
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, PPVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

#### Standard Scores

``` r
form_a_std <- form_a %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_a_std
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, PPVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

### Form NA checks

Assume that all tests with missing forms are just Form A tests.

``` r
form_na <- norm_check %>%
  filter(is.na(PPVT_Form)) %>%
  left_join(ppvt_norms) %>%
  select(Study:PPVT_Form, NormAge = Age, Raw, OurStnd, Stnd, OurGSV, GSV)
```

#### GSVs

``` r
form_na_gsv <- form_na %>% filter(OurGSV != GSV)
form_na_gsv
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, PPVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>
```

#### Standard Scores

``` r
form_na_std <- form_na %>% filter(OurStnd != Stnd) %>% arrange(Study, ID)
form_na_std
#> # A tibble: 0 × 9
#> # ... with 9 variables: Study <chr>, ID <chr>, PPVT_Form <chr>,
#> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
#> #   GSV <int>


results <- bind_rows(form_na_gsv, form_na_std, form_a_std, form_a_gsv)

results <- data_frame(
  Check = "PPVT",
  Date = format(Sys.Date()),
  Passing = nrow(results) == 0)

readr::write_csv(results, "./inst/audit/results_ppvt.csv")
```
