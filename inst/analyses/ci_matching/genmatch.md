Using genetic matching to pair normal-hearing children and children with cochlear implants
================
Tristan Mahr
2017-03-10

AJ hand-matched the children who participated in multiple lab-visits.

``` r
library(tidyverse)

# Load matching information
ci_pool <- read_csv("./inst/analyses/ci_matching/ci_matching_info.csv")
nh_pool <- read_csv("./inst/analyses/ci_matching/nh_matching_info.csv")

child_ids <- bind_rows(ci_pool, nh_pool) %>% 
  select(ChildID, ResearchID, Study)

matching_results <- list()

# Load hand-matched children
d <- read_csv("./inst/analyses/ci_matching/hand_matched.csv") %>% 
  inner_join(child_ids)

matching_results$manual <- d

d %>% 
  group_by(Hearing) %>% 
  summarise(
    nLabVisits = n(), 
    nFemaleVisits = sum(Female),
    nChildren = n_distinct(ChildID),
    MeanAge = mean(Age) %>% round(),
    MeanMedu = mean(Maternal_Education_Level) %>% round()) %>% 
  knitr::kable()
```

| Hearing         |  nLabVisits|  nFemaleVisits|  nChildren|  MeanAge|  MeanMedu|
|:----------------|-----------:|--------------:|----------:|--------:|---------:|
| CochlearImplant |          37|             23|         22|       49|         6|
| Normal          |          37|             23|         22|       49|         6|

Find out who still needs a match.

``` r
nh_leftover <- anti_join(nh_pool, d, by = "ChildID")
ci_leftover <- anti_join(ci_pool, d, by = "ChildID")

# Need matches
ci_leftover %>% select(ResearchID, Study, Age)
#> # A tibble: 7 × 3
#>   ResearchID      Study   Age
#>        <chr>      <chr> <int>
#> 1       303E CochlearV1    65
#> 2       800E CochlearV1    53
#> 3       800E CochlearV2    65
#> 4       802E CochlearV1    72
#> 5       803E CochlearV1    41
#> 6       805E CochlearV1    68
#> 7       809E CochlearV1    64

# Ignore 800E for now
ci_leftover <- ci_leftover %>% filter(ResearchID != "800E")

matching_pool <- bind_rows(nh_leftover, ci_leftover)
```

``` r
# Make a better interface for Matching::GenMatch
gen_match <- function(data, formula, ...) {
  tr <- lazyeval::f_eval_lhs(formula, data)
  x <- modelr::model_matrix(data, formula)
  Matching::GenMatch(Tr = tr, X = x, ...)
}

# GenMatch() returns a matrix with row-numbers. This helper gets those rows from
# a data-frame, and adds a MatchID column to include which observations were
# matched.
augment_genmatch <- function(data, genmatch) {
  long_matches <- genmatch$matches %>% 
    tibble::as_tibble() %>% 
    tibble::add_column(MatchID = seq_len(nrow(.)), .before = "V1") %>% 
    select(1:3) %>% 
    tidyr::gather(Group, RowNum, -MatchID) %>% 
    select(-Group)
  
  matched_data <- data %>% 
    tibble::rownames_to_column("RowNum") %>% 
    filter(RowNum %in% long_matches$RowNum) %>% 
    mutate(RowNum = as.numeric(RowNum)) %>% 
    left_join(long_matches) %>% 
    select(-RowNum) %>% 
    select(MatchID, everything())
  
  matched_data
}

matching_pool$Medu_LMMH <- case_when(
    matching_pool$Maternal_Education_Level %in% 1:3 ~ "Low",
    matching_pool$Maternal_Education_Level %in% 4:5 ~ "MidLow",
    matching_pool$Maternal_Education_Level %in% 6 ~ "MidPlus",
    matching_pool$Maternal_Education_Level %in% 7 ~ "Top"
)

# Do the matching
matched <- gen_match(
  data = matching_pool, 
  formula = CImplant ~ Age + Female + Medu_LMMH,
  ties = FALSE,
  replace = FALSE,
  pop.size = 1000)
#> 
#> 
#> Fri Mar 10 12:14:06 2017
#> Domains:
#>  0.000000e+00   <=  X1   <=    1.000000e+03 
#>  0.000000e+00   <=  X2   <=    1.000000e+03 
#>  0.000000e+00   <=  X3   <=    1.000000e+03 
#>  0.000000e+00   <=  X4   <=    1.000000e+03 
#>  0.000000e+00   <=  X5   <=    1.000000e+03 
#>  0.000000e+00   <=  X6   <=    1.000000e+03 
#> 
#> Data Type: Floating Point
#> Operators (code number, name, population) 
#>  (1) Cloning...........................  122
#>  (2) Uniform Mutation..................  125
#>  (3) Boundary Mutation.................  125
#>  (4) Non-Uniform Mutation..............  125
#>  (5) Polytope Crossover................  125
#>  (6) Simple Crossover..................  126
#>  (7) Whole Non-Uniform Mutation........  125
#>  (8) Heuristic Crossover...............  126
#>  (9) Local-Minimum Crossover...........  0
#> 
#> SOFT Maximum Number of Generations: 100
#> Maximum Nonchanging Generations: 4
#> Population size       : 1000
#> Convergence Tolerance: 1.000000e-03
#> 
#> Not Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
#> Not Checking Gradients before Stopping.
#> Using Out of Bounds Individuals.
#> 
#> Maximization Problem.
#> GENERATION: 0 (initializing the population)
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 1000, #Total UniqueCount: 1000
#> var 1:
#> best............ 8.396631e+02
#> mean............ 5.042158e+02
#> variance........ 8.404736e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 4.843286e+02
#> variance........ 8.375081e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 5.109364e+02
#> variance........ 8.190112e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 5.059472e+02
#> variance........ 8.357286e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 5.107992e+02
#> variance........ 8.878598e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.993611e+02
#> variance........ 8.586048e+04
#> 
#> GENERATION: 1
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 773, #Total UniqueCount: 1773
#> var 1:
#> best............ 8.396631e+02
#> mean............ 5.848543e+02
#> variance........ 8.358019e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 5.922282e+02
#> variance........ 3.175491e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 4.343968e+02
#> variance........ 3.696841e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 3.957126e+02
#> variance........ 4.101774e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 1.573630e+02
#> variance........ 6.228494e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.806521e+02
#> variance........ 6.024848e+04
#> 
#> GENERATION: 2
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 686, #Total UniqueCount: 2459
#> var 1:
#> best............ 8.396631e+02
#> mean............ 6.010400e+02
#> variance........ 7.946936e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 6.135907e+02
#> variance........ 1.838680e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 4.076881e+02
#> variance........ 2.544313e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 3.657783e+02
#> variance........ 2.608538e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 6.474661e+01
#> variance........ 1.549362e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.942992e+02
#> variance........ 4.383199e+04
#> 
#> GENERATION: 3
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 669, #Total UniqueCount: 3128
#> var 1:
#> best............ 8.396631e+02
#> mean............ 6.004091e+02
#> variance........ 7.634229e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 6.091332e+02
#> variance........ 1.823091e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 4.074814e+02
#> variance........ 2.324563e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 3.658969e+02
#> variance........ 2.796948e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 6.049164e+01
#> variance........ 1.194311e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.907922e+02
#> variance........ 4.320367e+04
#> 
#> GENERATION: 4
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 647, #Total UniqueCount: 3775
#> var 1:
#> best............ 8.396631e+02
#> mean............ 6.032101e+02
#> variance........ 7.339315e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 6.238302e+02
#> variance........ 1.367801e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 4.010799e+02
#> variance........ 1.937417e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 3.629702e+02
#> variance........ 2.536071e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 6.064880e+01
#> variance........ 1.243998e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.923572e+02
#> variance........ 4.081734e+04
#> 
#> GENERATION: 5
#> Lexical Fit..... 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> #unique......... 630, #Total UniqueCount: 4405
#> var 1:
#> best............ 8.396631e+02
#> mean............ 5.948709e+02
#> variance........ 7.441981e+04
#> var 2:
#> best............ 6.715488e+02
#> mean............ 6.089673e+02
#> variance........ 1.867667e+04
#> var 3:
#> best............ 3.309288e+02
#> mean............ 4.111921e+02
#> variance........ 2.174962e+04
#> var 4:
#> best............ 2.386077e+02
#> mean............ 3.673361e+02
#> variance........ 2.477687e+04
#> var 5:
#> best............ 3.632434e+01
#> mean............ 5.702566e+01
#> variance........ 1.039461e+04
#> var 6:
#> best............ 5.444267e+02
#> mean............ 4.823293e+02
#> variance........ 4.188495e+04
#> 
#> 'wait.generations' limit reached.
#> No significant improvement in 4 generations.
#> 
#> Solution Lexical Fitness Value:
#> 2.056873e-01  3.261642e-01  3.261642e-01  8.186212e-01  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  1.000000e+00  
#> 
#> Parameters at the Solution:
#> 
#>  X[ 1] : 8.396631e+02
#>  X[ 2] : 6.715488e+02
#>  X[ 3] : 3.309288e+02
#>  X[ 4] : 2.386077e+02
#>  X[ 5] : 3.632434e+01
#>  X[ 6] : 5.444267e+02
#> 
#> Solution Found Generation 1
#> Number of Generations Run 5
#> 
#> Fri Mar 10 12:14:13 2017
#> Total run time : 0 hours 0 minutes and 7 seconds


augment_genmatch(matching_pool, matched) %>% 
  arrange(MatchID, CImplant) %>% 
  select(Study, ResearchID, CImplant, MatchID, Age, 
         Female, Medu = Maternal_Education_Level) %>% 
  knitr::kable()
```

| Study            | ResearchID |  CImplant|  MatchID|  Age|  Female|  Medu|
|:-----------------|:-----------|---------:|--------:|----:|-------:|-----:|
| TimePoint3       | 097L       |         0|        1|   65|       1|     6|
| CochlearV1       | 303E       |         1|        1|   65|       1|     6|
| CochlearMatching | 393A       |         0|        2|   69|       0|     7|
| CochlearV1       | 802E       |         1|        2|   72|       0|     7|
| TimePoint2       | 006L       |         0|        3|   40|       1|     6|
| CochlearV1       | 803E       |         1|        3|   41|       1|     3|
| TimePoint3       | 133L       |         0|        4|   59|       0|     5|
| CochlearV1       | 805E       |         1|        4|   68|       0|     5|
| TimePoint3       | 101L       |         0|        5|   63|       0|     6|
| CochlearV1       | 809E       |         1|        5|   64|       0|     6|
