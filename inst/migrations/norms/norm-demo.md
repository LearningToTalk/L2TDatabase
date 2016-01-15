``` r
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "norm-demo-"
)
```

``` r
library("L2TDatabase")
library("dplyr")
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# Connect to norms database
cnf_file <- "inst/l2t_db.cnf"
norm_db <- l2t_connect(cnf_file, "norms")

# Download table and query some scores
evt_norms <- tbl(norm_db, "EVT2") %>% collect
evt_norms %>% filter(Raw == 30, Age %in% c(30, 40, 50))
#> Source: local data frame [3 x 10]
#> 
#>   EVT2ID  Form AgePage   Age   Raw   GSV  Stnd Percentile AgeEq
#>    (int) (chr)   (chr) (int) (int) (int) (int)      (dbl) (chr)
#> 1     31     A 2:6-2:7    30    30   110   112         79   3:0
#> 2   1941     A 3:4-3:5    40    30   110    95         37   3:0
#> 3   3851     A 4:2-4:3    50    30   110    80          9   3:0
#> Variables not shown: GradeEq (chr)

# Get field descriptions
describe_tbl(norm_db, "EVT2") %>% select(Field, Description)
#>         Field
#> 1      EVT2ID
#> 2        Form
#> 3     AgePage
#> 4         Age
#> 5         Raw
#> 6         GSV
#> 7        Stnd
#> 8  Percentile
#> 9       AgeEq
#> 10    GradeEq
#>                                                                      Description
#> 1                                    Row number / unique identifier of EVT norm.
#> 2                                                 Form of the test administered.
#> 3                                                    Standardized score bracket.
#> 4                                                         Age of child (months).
#> 5                                                             Raw score (words).
#> 6                                                            Growth scale value.
#> 7                                     Standardized score. Mean is 100, SD is 15.
#> 8  Percentile rank: Percentage of age-peer who performed at or below this score.
#> 9          Grade equivalent: Grade at which this raw score is the average score.
#> 10             Age equivalent: Age at which this raw score is the average score.

# Download table and query some scores
ppvt_norms <- tbl(norm_db, "PPVT4") %>% collect
ppvt_norms %>% filter(Raw == 30, Age %in% c(30, 40, 50))
#> Source: local data frame [3 x 10]
#> 
#>   PPVT2ID  Form AgePage   Age   Raw   GSV  Stnd Percentile AgeEq
#>     (int) (chr)   (chr) (int) (int) (int) (int)      (dbl) (chr)
#> 1      31     A 2:6-2:7    30    30    86    98         45   2:6
#> 2    2321     A 3:4-3:5    40    30    86    83         13   2:6
#> 3    4611     A 4:2-4:3    50    30    86    70          2   2:6
#> Variables not shown: GradeEq (chr)

# Get field descriptions
describe_tbl(norm_db, "PPVT4") %>% select(Field, Description)
#>         Field
#> 1     PPVT2ID
#> 2        Form
#> 3     AgePage
#> 4         Age
#> 5         Raw
#> 6         GSV
#> 7        Stnd
#> 8  Percentile
#> 9       AgeEq
#> 10    GradeEq
#>                                                                      Description
#> 1                                  Row number / unique identifier of PPVT4 norm.
#> 2                                                 Form of the test administered.
#> 3                                                    Standardized score bracket.
#> 4                                                         Age of child (months).
#> 5                                                             Raw score (words).
#> 6                                                            Growth scale value.
#> 7                                     Standardized score. Mean is 100, SD is 15.
#> 8  Percentile rank: Percentage of age-peer who performed at or below this score.
#> 9          Grade equivalent: Grade at which this raw score is the average score.
#> 10             Age equivalent: Age at which this raw score is the average score.
```
