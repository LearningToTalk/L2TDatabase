Demo of Household table
================

View a bit of the raw table.

``` r
library(dplyr)
library(L2TDatabase)

# Get the HouseholdIDs and ResearchIDs from the database
backend <- l2t_connect(cnf_file = "./inst/l2t_db.cnf", db_name = "backend")

tbl(backend, "Household") %>% 
  collect() %>% 
  head()
#> # A tibble: 6 x 8
#>   HouseholdID Household_NumAdults Household_NumAdultsContributeIncome
#>         <int>               <int>                               <int>
#> 1           1                   2                                   1
#> 2           2                   2                                   1
#> 3           3                   2                                   1
#> 4           4                   2                                   2
#> 5           5                   2                                   2
#> 6           6                   2                                   2
#> # ... with 5 more variables: Household_NumChildrenUnder18 <int>,
#> #   Household_FamilyIncome <chr>, Household_MaritalStatus <chr>,
#> #   Household_Timestamp <chr>, Household_Note <chr>
```

Demonstrate a query.

``` r
tbl(backend, "Household") %>% 
  left_join(tbl(backend, "Child")) %>% 
  select(ChildID, HouseholdID, Household_FamilyIncome) %>% 
  count(Household_FamilyIncome) %>% 
  collect()
#> # A tibble: 8 x 2
#>   Household_FamilyIncome     n
#>                    <chr> <dbl>
#> 1                   <NA>    11
#> 2   $101,000 to $200,000    90
#> 3     $20,000 to $40,000    44
#> 4     $41,000 to $60,000    44
#> 5    $61,000 to $100,000    77
#> 6      Less than $20,000    57
#> 7     More than $200,000    11
#> 8   Prefer not to answer     4
```
