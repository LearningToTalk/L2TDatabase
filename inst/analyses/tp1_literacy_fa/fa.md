# TP1 Literacy Factor Analysis
Tristan Mahr  
October 19, 2015  


```r
library("knitr")
opts_chunk$set(comment = "#>", collapse = TRUE)

library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)

# connect to the database using my cnf file
cnf_file <- file.path("../../l2t_db.cnf")
l2t <- l2t_connect(cnf_file)
```

First, we prepare the data-set by downloading the tables of child-study IDs, of 
study names, and of responses to the literacy survey. We combine those tables
together to generate the raw data-set.


```r
# Download child, study mappings
child_study <- "ChildStudy" %from% l2t %>% 
  left_join("Study" %from% l2t) %>% 
  collect
#> Joining by: "StudyID"

# Download literacy scores, attaching matching child-study columns
df_lit <- collect("Literacy" %from% l2t) %>% 
  inner_join(child_study)
#> Joining by: "ChildStudyID"

# Keep just the literarcy related columns
df_lit <- df_lit %>% 
  select(Study, ShortResearchID, ReadingBedtime:TeachReading, 
         Exclude, ExcludeNotes)
```

We next examine the kinds of responses in each literacy column. (`A data.frame` 
is a `list` of columns so using `lapply(df, func)` lets us apply a function to 
each column.)


```r
# Display the kinds of values in each column
df_lit %>% 
  select(ReadingBedtime:TeachReading) %>% 
  lapply(unique) %>% 
  lapply(sort)
#> $ReadingBedtime
#> [1] "0"           "1"           "2"           "3"           "4"          
#> [6] "5"           "6"           "7"           "more than 7"
#> 
#> $ReadingOther
#> [1] "0"           "1"           "2"           "3"           "4"          
#> [6] "5"           "6"           "7"           "more than 7"
#> 
#> $ReadingRequests
#> [1] 1 2 3 4 5
#> 
#> $NumChildBooks
#> [1] "1-20"         "21-40"        "41-60"        "61-80"       
#> [5] "more than 80"
#> 
#> $ReadingOnset
#>  [1] 0.00 0.08 0.10 0.20 0.25 0.30 0.33 0.42 0.50 0.60 0.67 0.75 1.00 1.50
#> [15] 2.00 3.00
#> 
#> $TeachPrinting
#> [1] 1 2 3 4 5
#> 
#> $TeachReading
#> [1] 1 2 3 4 5

# Count the number of NA values in each column
df_lit %>% 
  select(ReadingBedtime:TeachReading) %>% 
  lapply(function(xs) length(Filter(is.na, xs))) %>% 
  str
#> List of 7
#>  $ ReadingBedtime : int 0
#>  $ ReadingOther   : int 2
#>  $ ReadingRequests: int 4
#>  $ NumChildBooks  : int 1
#>  $ ReadingOnset   : int 8
#>  $ TeachPrinting  : int 0
#>  $ TeachReading   : int 0
```

Re-encode the literacy responses as ordinal measures. Conveniently, the ordering
of each column's values from smallest to largest is also the alphabetical order
of those values.


```r
# Ignore reading onset
df_lit$ReadingOnset <- NULL

# Set each column between from ReadingBedtime to TeachReading as ordinal
df_lit <- df_lit %>% 
  mutate_each(funs(factor(., order = TRUE)), ReadingBedtime:TeachReading)

# Confirm level orderings
df_lit %>% 
  lapply(levels) %>% 
  Filter(Negate(is.null), .)
#> $ReadingBedtime
#> [1] "0"           "1"           "2"           "3"           "4"          
#> [6] "5"           "6"           "7"           "more than 7"
#> 
#> $ReadingOther
#> [1] "0"           "1"           "2"           "3"           "4"          
#> [6] "5"           "6"           "7"           "more than 7"
#> 
#> $ReadingRequests
#> [1] "1" "2" "3" "4" "5"
#> 
#> $NumChildBooks
#> [1] "1-20"         "21-40"        "41-60"        "61-80"       
#> [5] "more than 80"
#> 
#> $TeachPrinting
#> [1] "1" "2" "3" "4" "5"
#> 
#> $TeachReading
#> [1] "1" "2" "3" "4" "5"
```

### Item Responses

Let's use the [`likert` package](https://github.com/jbryer/likert) to visualize
responses.


```r
library("likert")
#> Loading required package: ggplot2
#> Loading required package: xtable
df_likert <- df_lit
```

First, let's define some constants for our "codebook". We define a look-up 
vector of column names and column descriptions using the `describe_tbl` 
function. Three of the questions ask about the frequency of events, so we recode
their 1:5 values as "Never":"Very Often". The other questions--about reading at
bed time, reading outside of bed time and number of books in child's
house--already have informative values, so we don't touch those.


```r
# Used to convert column names to full-length questions
survey_description <- describe_tbl(l2t, "Literacy")
name_lookup <- survey_description$Description %>% 
  setNames(survey_description$Field)

frequency_labels <- c("Never", "Seldom", "Sometimes", "Often", "Very Often")

as_freq_q <- function(xs) {
  factor(xs, levels = 1:5, labels = frequency_labels, ordered = TRUE)
}

df_likert <- df_likert %>% 
  mutate_each(funs(as_freq_q), ReadingRequests, TeachPrinting, TeachReading)
```

We analyze the frequency items together:


```r
df_freq_data <- df_likert %>% 
  select(ReadingRequests, TeachPrinting, TeachReading) %>% 
  as.data.frame
names(df_freq_data) <- name_lookup[names(df_freq_data)]

df_freq_data <- likert(df_freq_data)
plot(df_freq_data, wrap = 20)
```

![](fa_files/figure-html/unnamed-chunk-7-1.png) 

```r
plot(df_freq_data, type = "heat", wrap = 20)
#> Warning: Non Lab interpolation is deprecated
```

![](fa_files/figure-html/unnamed-chunk-7-2.png) 

Next, we can visualize the reading frequencies together.


```r
df_reading <- df_likert %>% 
  select(ReadingBedtime, ReadingOther) %>% 
  as.data.frame
names(df_reading) <- name_lookup[names(df_reading)]
df_reading_data <- likert(df_reading)
plot(df_reading_data, wrap = 20)
```

![](fa_files/figure-html/unnamed-chunk-8-1.png) 


```r
plot(df_reading_data, type = "heat", wrap = 20)
#> Warning: Non Lab interpolation is deprecated
```

![](fa_files/figure-html/unnamed-chunk-9-1.png) 


Finally, we can visualize the number of books question.


```r
df_books <- df_likert %>% 
  select(NumChildBooks) %>% 
  as.data.frame
names(df_books) <- name_lookup[names(df_books)]

df_books_data <- likert(df_books)
plot(df_books_data, wrap = 30)
```

![](fa_files/figure-html/unnamed-chunk-10-1.png) 

```r
glimpse(df_books_data$results)
#> Observations: 1
#> Variables: 6
#> $ Item         (fctr) Estimate the number of children's books that are...
#> $ 1-20         (dbl) 8.737864
#> $ 21-40        (dbl) 13.59223
#> $ 41-60        (dbl) 13.59223
#> $ 61-80        (dbl) 28.64078
#> $ more than 80 (dbl) 35.43689
```


### Imputation

Impute missing values.


```r
library("mice")
#> Loading required package: Rcpp
#> Loading required package: lattice
#> mice 2.22 2014-06-10
library("tidyr")
#> 
#> Attaching package: 'tidyr'
#> 
#> The following object is masked from 'package:mice':
#> 
#>     complete

# Which rows have missing data
kids_with_missing_data <- df_lit %>% 
  gather(Item, Value, -Study, -ShortResearchID, -ExcludeNotes, -Exclude) %>% 
  filter(is.na(Value)) %>% 
  select(Study:ShortResearchID) %>% 
  distinct
#> Warning: attributes are not identical across measure variables; they will
#> be dropped
kids_with_missing_data$ShortResearchID
#> [1] "120L" "125L" "667L" "051L" "071L" "109L" "080L"

# Impute with default imputation methods (it will use "polr" (proportion odds
# model) because the values are ordinal)
df_values <- df_lit %>% select(ReadingBedtime:TeachReading)
imputed <- mice(df_values, m = 10, print = FALSE)
imputed
#> Multiply imputed data set
#> Call:
#> mice(data = df_values, m = 10, printFlag = FALSE)
#> Number of multiple imputations:  10
#> Missing cells per column:
#>  ReadingBedtime    ReadingOther ReadingRequests   NumChildBooks 
#>               0               2               4               1 
#>   TeachPrinting    TeachReading 
#>               0               0 
#> Imputation methods:
#>  ReadingBedtime    ReadingOther ReadingRequests   NumChildBooks 
#>              ""          "polr"          "polr"          "polr" 
#>   TeachPrinting    TeachReading 
#>              ""              "" 
#> VisitSequence:
#>    ReadingOther ReadingRequests   NumChildBooks 
#>               2               3               4 
#> PredictorMatrix:
#>                 ReadingBedtime ReadingOther ReadingRequests NumChildBooks
#> ReadingBedtime               0            0               0             0
#> ReadingOther                 1            0               1             1
#> ReadingRequests              1            1               0             1
#> NumChildBooks                1            1               1             0
#> TeachPrinting                0            0               0             0
#> TeachReading                 0            0               0             0
#>                 TeachPrinting TeachReading
#> ReadingBedtime              0            0
#> ReadingOther                1            1
#> ReadingRequests             1            1
#> NumChildBooks               1            1
#> TeachPrinting               0            0
#> TeachReading                0            0
#> Random generator seed value:  NA

# Combine original and imputed values
with_imputed <- df_lit %>% 
  bind_cols(mice::complete(imputed, "broad", include = TRUE)) %>% 
  # Drop unmarked columns since the ColName.0 columns have original values
  select(-(ReadingBedtime:ExcludeNotes)) %>%
  # Look only at rows with missing data
  semi_join(kids_with_missing_data) 
#> Joining by: c("Study", "ShortResearchID")

# Convert to long format, separate ColName.ImputationNum into separate columns,
# convert back to wide to show how each NA was imputed.
each_imputation <- with_imputed %>% 
  gather(Item, Value, -Study, -ShortResearchID) %>% 
  separate(Item, into = c("Item", "Imputation")) %>% 
  mutate(Imputation = paste0("Imp", Imputation),
         Imputation = ifelse(Imputation == "Imp0", "Raw", Imputation)) %>% 
  spread(Imputation, Value) %>% 
  filter(is.na(Raw)) %>% 
  select(ShortResearchID, Item, Raw, Imp1, Imp2:Imp9, Imp10) %>% 
  arrange(Item)
#> Warning: attributes are not identical across measure variables; they will
#> be dropped

kable(each_imputation, format = "markdown")
```



|ShortResearchID |Item            |Raw |Imp1  |Imp2         |Imp3  |Imp4  |Imp5  |Imp6         |Imp7  |Imp8         |Imp9         |Imp10 |
|:---------------|:---------------|:---|:-----|:------------|:-----|:-----|:-----|:------------|:-----|:------------|:------------|:-----|
|080L            |NumChildBooks   |NA  |61-80 |more than 80 |41-60 |21-40 |61-80 |more than 80 |41-60 |more than 80 |more than 80 |61-80 |
|120L            |ReadingOther    |NA  |2     |3            |2     |0     |4     |4            |2     |2            |6            |2     |
|125L            |ReadingOther    |NA  |2     |1            |0     |2     |3     |0            |0     |more than 7  |1            |4     |
|051L            |ReadingRequests |NA  |4     |3            |3     |5     |3     |3            |3     |5            |3            |4     |
|071L            |ReadingRequests |NA  |4     |5            |5     |5     |4     |5            |5     |3            |4            |5     |
|109L            |ReadingRequests |NA  |5     |4            |4     |4     |5     |5            |5     |5            |5            |5     |
|667L            |ReadingRequests |NA  |5     |4            |4     |4     |5     |3            |5     |5            |5            |5     |

Hmmm... the imputations look a little unstable. I need to see what else I can
include here, like including a measure of age at survey administration or
including other child-level measures.

