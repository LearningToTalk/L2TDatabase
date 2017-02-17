EVT Score Audit
================
Tristan Mahr
2017-02-01

Script to check for inconsistencies in the EVT scores in the database.

Preliminary checks
------------------

### Missing Dates

    #> # A tibble: 0 × 5
    #> # ... with 5 variables: Study <chr>, ID <chr>, Birthdate <chr>,
    #> #   EVT_Form <chr>, EVT_Completion <chr>

### Missing Forms

    #> [1] Study          ID             Birthdate      EVT_Form      
    #> [5] EVT_Completion
    #> <0 rows> (or 0-length row.names)

### Ages

Recompute test ages and compare to age in EVT table

    #> # A tibble: 0 × 5
    #> # ... with 5 variables: Study <chr>, ID <chr>, EVT_Completion <chr>,
    #> #   EVT_Age <int>, ChronoAge <dbl>

Derived Scores
--------------

### Form B scores

We cannot automatically check these scores because we only have the Form A norms.

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

### Form A checks

#### GSVs

    #> # A tibble: 0 × 9
    #> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
    #> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
    #> #   GSV <int>

#### Standard Scores

    #> # A tibble: 0 × 9
    #> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
    #> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
    #> #   GSV <int>

### Form NA checks

Assume that all tests with missing forms are just Form A tests.

#### GSVs

    #> # A tibble: 0 × 9
    #> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
    #> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
    #> #   GSV <int>

#### Standard Scores

    #> # A tibble: 0 × 9
    #> # ... with 9 variables: Study <chr>, ID <chr>, EVT_Form <chr>,
    #> #   NormAge <dbl>, Raw <int>, OurStnd <int>, Stnd <int>, OurGSV <int>,
    #> #   GSV <int>

Clean up
--------

Save results to a csv.
